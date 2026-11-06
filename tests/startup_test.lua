T.plugin 'lazy.nvim'
T.plugin 'toggleterm.nvim'
local root = vim.fn.getcwd()
for _, gui in ipairs { '0', '1' } do
  local lockfile = vim.fn.tempname()
  vim.fn.writefile(vim.fn.readfile 'lazy-lock.json', lockfile)
  local result = vim
    .system({
      vim.v.progpath,
      '--headless',
      '-i',
      'NONE',
      '-u',
      root .. '/tests/fixtures/startup_init.lua',
      root .. '/init.lua',
    }, { text = true, env = { AUDIT_CONFIG_ROOT = root, AUDIT_NEOVIDE = gui, AUDIT_LOCKFILE = lockfile } })
    :wait(15000)
  T.eq(0, result.code)
  T.eq('', result.stderr)
  local report = vim.json.decode(result.stdout)
  T.eq({}, report.errors)
  T.eq('', report.errmsg)
  T.eq('', report.messages)
  T.eq(gui == '1' and 800 or 500, report.timeoutlen)
  T.eq(gui == '1', report.plugins['toggleterm.nvim'] == true)
  T.eq(2, report.lazydev)
  T.eq('default', report.snippets)
  T.eq('Select inner part of a loop', report.loop)
  T.eq('Swap next function', report.swap)
  T.eq('[S]earch files by [M]odified date', report.search)
  for _, removed in ipairs { 'nvim-lint', 'LuaSnip', 'Comment.nvim' } do
    T.eq(nil, report.plugins[removed])
  end
  local lock = vim.json.decode(table.concat(vim.fn.readfile(lockfile), '\n'))
  T.eq('50ea089fc548917cc3cc16b46a8211833b9e3c7c', lock['toggleterm.nvim'].commit)
  vim.fn.delete(lockfile)
end
