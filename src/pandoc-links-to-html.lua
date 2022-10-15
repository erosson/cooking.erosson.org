-- https://stackoverflow.com/a/49396058/2782048
-- links-to-html.lua
function Link(el)
  el.target = string.gsub(el.target, "%.md", ".html")
  return el
end