-- A deliberately small frontmatter format: a top-level tags key containing
-- strings in a scalar, a one-line [...] list, or a block list. YAML aliases,
-- mappings, multiline strings, and multiline flow lists are not supported.
local M = {}

local function strip_comment(text)
  local quote, i = nil, 1
  while i <= #text do
    local char = text:sub(i, i)
    if quote then
      if char == '\\' and quote == '"' then
        i = i + 1
      elseif char == quote then
        if quote == "'" and text:sub(i + 1, i + 1) == "'" then
          i = i + 1
        else
          quote = nil
        end
      end
    elseif char == '"' or char == "'" then
      quote = char
    elseif char == '#' and (i == 1 or text:sub(i - 1, i - 1):match '%s') then
      return vim.trim(text:sub(1, i - 1))
    end
    i = i + 1
  end
  return vim.trim(text)
end

local function value(text)
  text = vim.trim(text)
  if text:sub(1, 1) == '"' then
    local ok, decoded = pcall(vim.json.decode, text)
    if ok and type(decoded) == 'string' then
      return decoded
    end
    error 'Invalid double-quoted tag'
  elseif text:sub(1, 1) == "'" then
    assert(text:sub(-1) == "'" and #text >= 2, 'Unterminated single-quoted tag')
    local inner = text:sub(2, -2)
    assert(not inner:gsub("''", ''):find("'", 1, true), 'Invalid single-quoted tag')
    return (inner:gsub("''", "'"))
  end
  assert(not text:find '[%[%]{}"\']' and not text:match '^[&*!|>]' and not text:find ':%s', 'Unsupported tag syntax')
  return text
end

local function values(text, separators)
  local result, start, quote, i = {}, 1, nil, 1
  while i <= #text do
    local char = text:sub(i, i)
    if quote then
      if char == '\\' and quote == '"' then
        i = i + 1
      elseif char == quote then
        if quote == "'" and text:sub(i + 1, i + 1) == "'" then
          i = i + 1
        else
          quote = nil
        end
      end
    elseif char == '"' or char == "'" then
      quote = char
    elseif char:match(separators) then
      local part = vim.trim(text:sub(start, i - 1))
      if part ~= '' then
        table.insert(result, value(part))
      end
      start = i + 1
    end
    i = i + 1
  end
  assert(not quote, 'Unterminated quoted tag')
  local part = vim.trim(text:sub(start))
  if part ~= '' then
    table.insert(result, value(part))
  end
  return result
end

function M.parse(lines)
  local ok, result = pcall(function()
    local tags, in_tags, found = {}, false, false
    for _, raw in ipairs(lines) do
      local line = strip_comment(raw:gsub('\r$', ''))
      -- Inspect the original indentation: only a top-level key is a tag key.
      local rest = raw:match '^tags:%s*(.*)$'
      if rest then
        assert(not found, 'Duplicate tags key')
        found = true
        rest = strip_comment(rest)
        if rest == '' then
          in_tags = true
        elseif rest:sub(1, 1) == '[' then
          assert(rest:sub(-1) == ']', 'Tags flow lists must fit on one line')
          tags = values(rest:sub(2, -2), ',')
        else
          tags = values(rest, '[,%s]')
        end
      elseif in_tags and line ~= '' then
        local item = line:match '^%-%s+(.+)$'
        if item then
          table.insert(tags, value(item))
        elseif raw:match '^%S' then
          in_tags = false
        else
          error 'Unsupported tags block item'
        end
      end
    end
    local unique, seen = {}, {}
    for _, tag in ipairs(tags) do
      if tag ~= '' and not seen[tag] then
        table.insert(unique, tag)
        seen[tag] = true
      end
    end
    return unique
  end)
  if ok then
    return result
  end
  return nil, result
end

function M.read(path)
  local file, err = io.open(path, 'r')
  if not file then
    return nil, err
  end
  local first = file:read '*l'
  if not first or not first:match '^%-%-%-%s*$' then
    file:close()
    return {}
  end
  local lines = {}
  for line in file:lines() do
    if line:match '^%-%-%-%s*$' or line:match '^%.%.%.%s*$' then
      file:close()
      return M.parse(lines)
    end
    table.insert(lines, line)
  end
  file:close()
  return nil, 'Unterminated frontmatter'
end

return M
