local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- procon template
  s(
    { trig = "actemplate" },
    {
      t({
        "use proconio::input;",
        "",
        "fn main() {",
        "    input! {",
        "        ",
      }),
      i(1),
      t({
        "",
        "    }",
        "}",
      }),
    }
  ),

  -- グリッド上の移動
  s(
    { trig = "acdij" },
    { t({
      "const DIJ: [[usize; 2]; 4] = [",
      "    [1, 0],",
      "    [0, 1],",
      "    [1usize.wrapping_neg(), 0],",
      "    [0, 1usize.wrapping_neg()],",
      "];",
    }) }
  ),

  -- グリッド上の隣接するマスを列挙するイテレータ
  s(
    { trig = "acneighboriter" },
    {
      t({
        "DIJ",
        "    .iter()",
        "    .map(move |&[di, dj]| (i.wrapping_add(di), j.wrapping_add(dj)))",
        "    .filter(move |&(i, j)| i < h && j < w)",
        -- "    "
      }),
    }
  ),

  -- グリッド状で隣接するマスに対するfor
  s(
    { trig = "acneighborfor" },
    {
      t({
        "for (ni, nj) in DIJ",
        "    .iter()",
        "    .map(move |&[di, dj]| (i.wrapping_add(di), j.wrapping_add(dj)))",
        "    .filter(move |&(i, j)| i < h && j < w) {",
        "    "
      }),
      i(1),
      t({
        "",
        "}"
      })
    }
  ),

  -- 重みなしグラフ
  s(
    { trig = "acgraph1" },
    {
      t({
        "let g = {",
        "    let mut g = vec![vec![]; n];",
        "    for &(u, v) in &edges {",
        "        g[u].push(v);",
        "        // g[v].push(u);",
        "    }",
        "    g",
        "};"
      })
    }
  ),

  -- 重みつきグラフ
  s(
    { trig = "acgraph2" },
    {
      t({
        "let g = {",
        "    let mut g = vec![vec![]; n];",
        "    for &(u, v, c) in &edges {",
        "        g[u].push((v, c));",
        "        // g[v].push((u, c));",
        "    }",
        "    g",
        "};"
      })
    }
  ),
}
