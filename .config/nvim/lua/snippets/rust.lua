local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  -- procon template
  s(
    { trig = "mainpr" },
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

  -- procon template(proconioが使えないとき)
  s(
    { trig = "mainpr2" },
    {
      t({
        "use std::io::{Read, Write};",
        "",
        "fn main() {",
        "    let s = {",
        "        let mut s = String::new();",
        "        std::io::stdin().read_to_string(&mut s).unwrap();",
        "        s",
        "    };",
        "    let mut stdin = s.split_whitespace();",
        "    let mut stdout = std::io::BufWriter::new(std::io::stdout().lock());",
        "",
        "    ",
      }),
      i(1),
      t({
        "",
        "}",
        "",
        "#[inline]",
        "fn read<T>(iter: &mut std::str::SplitWhitespace<'_>) -> T",
        "where",
        "    T: std::str::FromStr,",
        "    T::Err: std::fmt::Debug,",
        "{",
        "    iter.next().unwrap().parse::<T>().unwrap()",
        "}",
      }),
    }
  ),

  -- クエリ
  s(
    { trig = "query" },
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
    { trig = "dij" },
    { t({
      "const DIJ: [[usize; 2]; 4] = [",
      "    [0, 1],",
      "    [1, 0],",
      "    [0, 1usize.wrapping_neg()],",
      "    [1usize.wrapping_neg(), 0],",
      "];",
    }) }
  ),

  -- グリッド上の隣接するマスを列挙するイテレータ
  s(
    { trig = "neighbor" },
    {
      t({
        "DIJ",
        "    .iter()",
        "    .map(|&[di, dj]| [i.wrapping_add(di), j.wrapping_add(dj)])",
        "    .filter(|&[ni, nj]| ni < h && nj < w)",
      }),
    }
  ),

  -- グリッド状で隣接するマスに対するfor
  s(
    { trig = "neigborfor" },
    {
      t({
        "for [ni, nj] in DIJ",
        "    .iter()",
        "    .map(|&[di, dj]| [i.wrapping_add(di), j.wrapping_add(dj)])",
        "    .filter(|&[ni, nj]| ni < h && nj < w) {",
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
    { trig = "graph" },
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
    { trig = "graphw" },
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

  -- bfs
  s(
    { trig = "bfs" },
    {
      t({
        "let bfs = Bfs::new(n, &s, |&v| v, |&v| g[v].iter().cloned());"
      })
    }
  ),

  -- dijkstra
  s(
    { trig = "dijkstra" },
    {
      t({
        "let dijkstra = Dijkstra::new(n, &s, &0, |&v| v, |&v| g[v].iter().cloned());"
      })
    }
  ),

  -- モノイド(セグ木)
  s(
    { trig = "mono" },
    {
      t({
        "#[derive(Clone, Default)]",
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

  -- モノイド作用(遅延セグ木)
  s(
    { trig = "act" },
    {
      t({
        "#[derive(Clone, Default)]",
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
