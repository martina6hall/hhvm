(**
 * Copyright (c) 2016, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the "hack" directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 *)

module WithSyntax(Syntax : Syntax_sig.Syntax_S) = struct
  module Context = Full_fidelity_parser_context.WithToken(Syntax.Token)
  module type Lexer_S = Full_fidelity_lexer_sig.WithToken(Syntax.Token).Lexer_S
  module WithLexer(Lexer : Lexer_S) = struct
    module type StatementParser_S = sig
      module SC : SmartConstructors.SmartConstructors_S
      type t
      val make : Full_fidelity_parser_env.t
        -> Lexer.t
        -> Full_fidelity_syntax_error.t list
        -> Full_fidelity_parser_context.WithToken(Syntax.Token).t
        -> SC.t
        -> t
      val sc_call : t -> (SC.t -> SC.t * SC.r) -> t * SC.r
      val lexer : t -> Lexer.t
      val errors : t -> Full_fidelity_syntax_error.t list
      val context : t -> Context.t
      val env : t -> Full_fidelity_parser_env.t
      val sc_state : t -> SC.t
      val parse_alternate_loop_statement : t -> terminator:Full_fidelity_token_kind.t ->
        t * Syntax.t
      val parse_compound_statement : t -> t * Syntax.t
      val parse_statement : t -> t * Syntax.t
      val parse_markup_section: t ->
        is_leading_section:bool ->
        t * Syntax.t * bool
      val parse_possible_php_function: t -> t * Syntax.t
    end (* StatementParser_S *)
  end (* WithLexer *)
end (* WithSyntax *)
