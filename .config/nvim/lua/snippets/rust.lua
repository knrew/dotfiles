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

  -- クエリ
  s(
    { trig = "acquery" },
    {
      t({
        "enum Query {",
        "    Q1(usize),",
        "    Q2(usize),",
        "}",
        "use Query::*;",
        "",
        "impl proconio::source::Readable for Query {",
        "    type Output = Self;",
        "    fn read<R: std::io::BufRead, S: proconio::source::Source<R>>(source: &mut S) -> Self::Output {",
        "        match u8::read(source) {",
        "            1 => {",
        "                input! {",
        "                    from source,",
        "                    x: usize,",
        "                }",
        "                Q1(x)",
        "            }",
        "            2 => {",
        "                input! {",
        "                    from source,",
        "                    x: usize,",
        "                }",
        "                Q2(x)",
        "            }",
        "            _ => unreachable!(),",
        "        }",
        "    }",
        "}",
      })
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
    { trig = "acneighbor" },
    {
      t({
        "DIJ",
        "    .iter()",
        "    .map(move |&[di, dj]| [i.wrapping_add(di), j.wrapping_add(dj)])",
        "    .filter(move |&[ni, nj]| ni < h && nj < w)",
      }),
    }
  ),

  -- グリッド状で隣接するマスに対するfor
  s(
    { trig = "acneigborfor" },
    {
      t({
        "for (ni, nj) in DIJ",
        "    .iter()",
        "    .map(move |&[di, dj]| [i.wrapping_add(di), j.wrapping_add(dj)])",
        "    .filter(move |&[ni, nj]| ni < h && nj < w) {",
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
    { trig = "acgraph" },
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
    { trig = "acgraphw" },
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

  -- モノイド(セグ木)
  s(
    { trig = "acseg" },
    {
      t({
        "#[derive(Default)]",
        "struct Op;",
        "",
        "impl Monoid for Op {",
        "    type Value = todo!();",
        "",
        "    fn identity(&self) -> Self::Value {",
        "        todo!()",
        "    }",
        "",
        "    fn op(&self, x: &Self::Value, y: &Self::Value) -> Self::Value {",
        "        todo!()",
        "    }",
        "}",
      })
    }
  ),

  -- モノイドアクション(遅延セグ木)
  s(
    { trig = "aclazyseg" },
    {
      t({
        "#[derive(Default)]",
        "struct Op;",
        "",
        "impl Monoid for Op {",
        "    type Value = todo!();",
        "",
        "    fn identity(&self) -> Self::Value {",
        "        todo!()",
        "    }",
        "",
        "    fn op(&self, x: &Self::Value, y: &Self::Value) -> Self::Value {",
        "        todo!()",
        "    }",
        "}",
        "",
        "#[derive(Default)]",
        "struct Act;",
        "",
        "impl Monoid for Act {",
        "    type Value = todo!();",
        "",
        "    fn identity(&self) -> Self::Value {",
        "        todo!()",
        "    }",
        "",
        "    // NOTE: gが後に作用する．g(f(x))",
        "    fn op(&self, g: &Self::Value, f: &Self::Value) -> Self::Value {",
        "        todo!()",
        "    }",
        "}",
        "",
        "impl Action<Op> for Act {",
        "    fn act(&self, f: &Self::Value, x: &<Op as Monoid>::Value) -> <Op as Monoid>::Value {",
        "        todo!()",
        "    }",
        "}",
      })
    }
  ),
}
