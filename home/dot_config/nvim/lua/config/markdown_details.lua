--- Folds HTML <details> blocks in markdown, labelled with their <summary>.
local M = {}

local function opens_details(line)
  return line:match("^%s*<details[%s>]") ~= nil
end

local function closes_details(line)
  return line:match("</details>%s*$") ~= nil
end

--- 'foldexpr': one fold level per <details> block, nesting allowed.
function M.foldexpr()
  local line = vim.fn.getline(vim.v.lnum)
  if opens_details(line) then
    return "a1"
  end
  if closes_details(line) then
    return "s1"
  end

  return "="
end

--- 'foldtext': the block's <summary> text and its size.
function M.foldtext()
  local first, last = vim.v.foldstart, vim.v.foldend
  for lnum = first, math.min(first + 3, last) do
    local summary = vim.fn.getline(lnum):match("<summary>(.-)</summary>")
    if summary then
      return string.format("▸ %s  (%d lines)", summary, last - first + 1)
    end
  end

  return vim.fn.foldtext()
end

return M
