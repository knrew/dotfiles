local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s(
    { trig = "actemplate" },
    {
      t({
        "use proconio::input;",
        "",
        "fn main() {",
        "    input! {",
      }),
      i(1),
      t({
        "}",
        "}",
      }),
    }
  ),
}
