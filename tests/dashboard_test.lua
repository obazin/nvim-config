T.plugin 'dashboard-nvim'
local root = vim.fn.getcwd()
local directory = vim.fn.tempname()
vim.fn.mkdir(directory .. '/project', 'p')
local function launch(args, stdin)
  local cmd = { vim.v.progpath, '--headless', '-i', 'NONE', '-u', root .. '/tests/fixtures/dashboard_init.lua' }
  vim.list_extend(cmd, args)
  local result = vim
    .system(cmd, {
      cwd = directory,
      env = { AUDIT_CONFIG_ROOT = root },
      stdin = stdin,
      text = true,
    })
    :wait(5000)
  T.eq(0, result.code)
  T.eq('', result.stderr)
  return vim.json.decode(result.stdout)
end
for _, argument in ipairs { 'project', directory .. '/project' } do
  local result = launch { argument }
  T.eq(directory .. '/project', result.cwd)
  T.eq('dashboard', result.ft)
end
local piped = launch({ '-' }, 'piped content\n')
T.eq({ 'piped content' }, piped.lines)
assert(piped.ft ~= 'dashboard')
T.eq('dashboard', launch({}).ft)
vim.fn.writefile({ 'a regular file' }, directory .. '/file.txt')
local file = launch { 'file.txt' }
T.eq({ 'a regular file' }, file.lines)
assert(file.ft ~= 'dashboard')
vim.fn.delete(directory, 'rf')
