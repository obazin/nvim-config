local tags = require 'custom.note-tags'
local cases = {
  { {}, { 'not_tags: [work]', '# tags: [work]', 'nested:', '  tags: [work]' } },
  { { 'work', 'lua' }, { 'tags: [work, lua]' } },
  { { 'work', 'lua' }, { 'tags: work lua,work' } },
  { { 'work', 'lua' }, { 'tags:', '- work # a comment', '', '# comment', '  - lua', 'title: note', '- ignored' } },
  { { 'work', 'lua' }, { 'tags:\r', '- work\r', '- lua\r' } },
  { { 'a,b', 'c # d', "it's" }, { [[tags: ["a,b", 'c # d', 'it''s'] # comment]] } },
  { { 'tag' }, { 'tags: [tag, tag]' } },
}
for _, case in ipairs(cases) do
  T.eq(case[1], tags.parse(case[2]))
end
for _, lines in ipairs {
  { 'tags: [unfinished' },
  { 'tags: *alias' },
  { 'tags: ["unclosed]' },
  { 'tags: one', 'tags: two' },
} do
  local result, err = tags.parse(lines)
  T.eq(nil, result)
  assert(err)
end
local path = vim.fn.tempname()
vim.fn.writefile({ '---', 'description: ' .. string.rep('x', 5000), 'tags: [late]', '---', 'body' }, path)
T.eq({ 'late' }, tags.read(path))
vim.fn.writefile({ '---', 'tags: [open]' }, path)
local result, err = tags.read(path)
T.eq(nil, result)
assert(err)
vim.fn.writefile({ '# Ordinary Markdown', 'tags: [not-frontmatter]' }, path)
T.eq({}, tags.read(path))
vim.fn.delete(path)
