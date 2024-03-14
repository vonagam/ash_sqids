[
  import_deps: [:ash],
  plugins: [FreedomFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test,bench}/**/*.{heex,ex,exs}"],
  line_length: 120,
  # freedom
  trailing_comma: true,
  local_pipe_with_parens: true,
  single_clause_on_do: true,
]
