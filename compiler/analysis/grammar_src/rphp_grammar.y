/* ***** BEGIN LICENSE BLOCK *****
;; Roadsend PHP Compiler
;;
;; Copyright (c) 2008-2010 Shannon Weyrick <weyrick@roadsend.com>
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA
   ***** END LICENSE BLOCK *****
*/

%include {   

#include "rphp/pSourceTypes.h"
#include "rphp/analysis/pAST.h"
#include "rphp/analysis/pSourceModule.h"

#include <iostream>
#include <string>
#include <cctype> // for toupper
#include <algorithm>
#include <unicode/unistr.h>

using namespace rphp;

#define CTXT          pMod->context()
#define TOKEN_LINE(T) CTXT.getTokenLine(T)
#define CURRENT_LINE  CTXT.currentLineNum()

AST::literalExpr* extractLiteralString(pSourceRange* B, pSourceModule* pMod, bool isSimple) {
  // binary specifier?
  bool binaryString = false;
  pSourceCharIterator start;
  if ( *(*B).begin() == 'b') {
      // binary
      binaryString = true;
      start = ++(*B).begin();
  }
  else {
      // according to module default
      start = (*B).begin();
  }
  // substring out the quotes, special case for empty string
  AST::literalString* A;
  if (++start == (*B).end()) {
    A = new (CTXT) AST::literalString(binaryString);
  }
  else {
    A = new (CTXT) AST::literalString(pSourceRange(start, --(*B).end()), binaryString);
  }
  A->setIsSimple(isSimple);
  return A;
}

}  

%name rphpParse
%token_type {pSourceRange*}
%default_type {pSourceRange*}
%extra_argument {pSourceModule* pMod}


// tokens that don't need parse info or AST nodes
%type T_WHITESPACE {int}
%type T_OPEN_TAG {int}
%type T_CLOSE_TAG {int}
%type T_LEFTPAREN {int}
%type T_RIGHTPAREN {int}
%type T_LEFTCURLY {int}
%type T_RIGHTCURLY {int}
%type T_LEFTSQUARE {int}
%type T_RIGHTSQUARE {int}
%type T_COMMA {int}
%type T_SINGLELINE_COMMENT {int}
%type T_MULTILINE_COMMENT {int}
%type T_DOC_COMMENT {int}
%type T_INLINE_HTML {int}
%type T_WHILE {int}
%type T_ENDWHILE {int}
%type T_ELSE {int}
%type T_ELSEIF {int}
%type T_ARRAY {int}
%type T_ARROWKEY {int}
%type T_AND {int}
%type T_ASSIGN {int}
%type T_DQ_STRING {int}
//We need _LIT versions here for 'and', 'or' and 'xor' because these have another precedence than '&&' and  '||'
//but finally we want them to look like the normal ast nodes.
%type T_BOOLEAN_AND {int}
%type T_BOOLEAN_AND_LIT {int}
%type T_BOOLEAN_OR {int}
%type T_BOOLEAN_OR_LIT {int}
%type T_BOOLEAN_XOR_LIT {int}
%type T_BOOLEAN_NOT {int}
%type T_IDENTIFIER {int}
%type T_GLOBAL {int}
%type T_FUNCTION {int}
%type T_EMPTY {int}
%type T_EQUAL {int}
%type T_NOT_EQUAL {int}
%type T_ISSET {int}
%type T_UNSET {int}
%type T_VAR {int}
%type T_CLASS {int}
%type T_CLASSDEREF {int}
%type T_FOREACH {int}
%type T_ENDFOREACH {int}
%type T_FOR {int}
%type T_ENDFOR {int}
%type T_AS {int}
%type T_RETURN {int}
%type T_DOT {int}
%type T_GREATER_THAN {int}
%type T_LESS_THAN {int}
%type T_GREATER_OR_EQUAL {int}
%type T_LESS_OR_EQUAL {int}
%type T_LIST {int}
%type T_EXTENDS {int}
%type T_PUBLIC {int}
%type T_PRIVATE {int}
%type T_PROTECTED {int}
//%type T_INCLUDE {int}
//%type T_INCLUDE_ONCE {int}
//%type T_REQUIRE {int}
//%type T_REQUIRE_ONCE {int}
%type T_IDENTICAL {int}
%type T_NOT_IDENTICAL {int}
%type T_QUESTION {int}
%type T_COLON {int}
%type T_DBL_COLON {int}
%type T_INC {int}
%type T_DEC {int}
%type T_EXIT {int}
%type T_MINUS {int}
%type T_PLUS {int}
%type T_DIV {int}
%type T_MOD {int}
%type T_MULT {int}
%type T_SWITCH {int}
%type T_ENDSWITCH {int}
%type T_CASE {int}
%type T_BREAK {int}
%type T_CONTINUE {int}
%type T_DEFAULT {int}
%type T_CLONE {int}
%type T_TRY {int}
%type T_CATCH {int}
%type T_THROW {int}
%type T_STATIC {int}
%type T_CONST {int}
%type T_AT {int}
%type T_INSTANCEOF {int}
%type T_PLUS_EQUAL {int}
%type T_MINUS_EQUAL {int}
%type T_EVAL {int}
%type T_SR_EQUAL {int}
%type T_SL_EQUAL {int}
%type T_XOR_EQUAL {int}
%type T_OR_EQUAL {int}
%type T_AND_EQUAL {int}
%type T_MOD_EQUAL {int}
%type T_CONCAT_EQUAL {int}
%type T_DIV_EQUAL {int}
%type T_MUL_EQUAL {int}
%type T_SR {int}
%type T_SL {int}
%type T_NAMESPACE {int}
%type T_INT_CAST {int}
%type T_FLOAT_CAST {int}
%type T_STRING_CAST {int}
%type T_UNICODE_CAST {int}
%type T_BINARY_CAST {int}
%type T_ARRAY_CAST {int}
%type T_OBJECT_CAST {int}
%type T_UNSET_CAST {int}
%type T_BOOL_CAST {int}
%type T_GOTO {int}
%type T_MAGIC_FILE {int}
%type T_MAGIC_LINE {int}
%type T_MAGIC_NS {int}
%type T_MAGIC_CLASS {int}
%type T_MAGIC_FUNCTION {int}
%type T_MAGIC_METHOD {int}
%type T_TICK {int}
%type T_TILDE {int}
%type T_PIPE {int}
%type T_CARET {int}
%type T_PRINT {int}
%type T_INTERFACE {int}

// double quote parsing
%type T_DQ_DONE {int}
%type T_DQ_DQ  {int}
%type T_DQ_NEWLINE  {int}
%type T_DQ_VARIABLE  {int}
%type T_DQ_ESCAPE  {int}

%syntax_error {  
  CTXT.parseError(TOKEN);
}   
%stack_overflow {  
  std::cerr << "Parser stack overflow" << std::endl;
}   

/** ASSOCIATIVITY AND PRECEDENCE (low to high) **/
%left T_COMMA.
%left T_BOOLEAN_OR_LIT.
%left T_BOOLEAN_XOR_LIT.
%left T_BOOLEAN_AND_LIT.
%right T_PRINT.
%left T_ASSIGN T_CONCAT_EQUAL T_AND_EQUAL T_OR_EQUAL T_XOR_EQUAL T_PLUS_EQUAL T_MINUS_EQUAL T_MOD_EQUAL T_DIV_EQUAL T_MUL_EQUAL.
%left T_BOOLEAN_AND T_BOOLEAN_OR.
%left T_PIPE.
%left T_CARET.
%left T_AND.
%nonassoc T_EQUAL T_NOT_EQUAL T_IDENTICAL T_NOT_IDENTICAL.
%nonassoc T_GREATER_THAN T_LESS_THAN T_GREATER_OR_EQUAL T_LESS_OR_EQUAL.
%left T_PLUS T_MINUS T_DOT.
%left T_DIV T_MOD T_MULT.
%right T_BOOLEAN_NOT.
%right T_INC T_DEC T_FLOAT_CAST T_STRING_CAST T_BINARY_CAST T_UNICODE_CAST T_ARRAY_CAST T_OBJECT_CAST T_INT_CAST T_BOOL_CAST T_UNSET_CAST.
%nonassoc T_NEW.
%left T_ELSE T_ELSEIF.

/** GOAL **/
%type module {int}
module ::= statement_list(LIST). { pMod->setAST(LIST); delete LIST; }

%type statement_list {AST::statementList*}
statement_list(A) ::= . { A = new AST::statementList(); }
statement_list(A) ::= statement_list(B) statement(C). { B->push_back(C); A = B; }

/******** STATEMENTS ********/
%type statement {AST::stmt*}
statement(A) ::= statementBlock(B). { A = B; }
statement(A) ::= inlineHTML(B). { A = B; }
statement(A) ::= staticDecl(B). { A = B; }
statement(A) ::= functionDecl(B). { A = B; }
statement(A) ::= ifBlock(B). { A = B; }
statement(A) ::= forEach(B). { A = B; }
statement(A) ::= forStmt(B). { A = B; }
statement(A) ::= doStmt(B). { A = B; }
statement(A) ::= whileStmt(B). { A = B; }
statement(A) ::= switchStmt(B). { A = B; }
statement(A) ::= echo(B) T_SEMI. { A = B; }
statement(A) ::= expr(B) T_SEMI. { A = B; }
statement(A) ::= return(B) T_SEMI. { A = B; }
statement(A) ::= break(B) T_SEMI. { A = B; }
statement(A) ::= continue(B) T_SEMI. { A = B; }
statement(A) ::= global(B) T_SEMI. { A = B; }
statement(A) ::= T_SEMI.
{
    A = new (CTXT) AST::emptyStmt();
}

// statement block
%type statementBlock{AST::block*}
statementBlock(A) ::= T_LEFTCURLY(LC) statement_list(B) T_RIGHTCURLY(RC).
{
    A = new (CTXT) AST::block(CTXT, B);
    A->setLine(TOKEN_LINE(LC), TOKEN_LINE(RC));
    delete B;
}

// echo
%type echo {AST::builtin*}
echo(A) ::= T_ECHO commaExprList(EXPRS).
{
   A = new (CTXT) AST::builtin(CTXT, AST::builtin::ECHO, EXPRS);
   A->setLine(CURRENT_LINE);
   delete EXPRS;
}

// return
%type return {AST::returnStmt*}
return(A) ::= T_RETURN.
{
    A = new (CTXT) AST::returnStmt(NULL);
    A->setLine(CURRENT_LINE);
}
return(A) ::= T_RETURN expr(B).
{
    A = new (CTXT) AST::returnStmt(B);
    A->setLine(CURRENT_LINE);
}
// break
%type break {AST::breakStmt*}
break(A) ::= T_BREAK.
{
    A = new (CTXT) AST::breakStmt(NULL);
    A->setLine(CURRENT_LINE);
}
break(A) ::= T_BREAK expr(B).
{
    A = new (CTXT) AST::breakStmt(B);
    A->setLine(CURRENT_LINE);
}
// continue
%type continue {AST::continueStmt*}
continue(A) ::= T_CONTINUE.
{
    A = new (CTXT) AST::continueStmt(NULL);
    A->setLine(CURRENT_LINE);
}
continue(A) ::= T_CONTINUE expr(B).
{
    A = new (CTXT) AST::continueStmt(B);
    A->setLine(CURRENT_LINE);
}

// global
%type global {AST::globalStmt*}
global(A) ::= T_GLOBAL globalItemList(B).
{
    A = new (CTXT) AST::globalStmt(CTXT, B);
    A->setLine(CURRENT_LINE);
    delete B;
}

%type globalItemList {AST::globalItemList*}
globalItemList(A) ::= lval(B).
{
    A = new AST::globalItemList();
    A->push_back(static_cast<AST::stmt*>(B)); // copy item into vector
}
globalItemList(A) ::= lval(B) T_COMMA globalItemList(C).
{
    C->push_back(static_cast<AST::stmt*>(B)); // copy item into vector
    A = C;
}

// inline html
%type inlineHTML {AST::inlineHtml*}
inlineHTML(A) ::= T_INLINE_HTML(B).
{
    A = new (CTXT) AST::inlineHtml(*B);
    A->setLine(CURRENT_LINE);
}

// conditionals
%type elseSingle {AST::stmt*}
// empty else
elseSingle(A) ::= . { A = NULL; }
// simple else
elseSingle(A) ::= T_ELSE statement(BODY).
{
    A = BODY;
}

// else series
%type elseSeries{AST::stmt*}
// elseif with (potential) single statement
elseSeries(A) ::=  T_ELSEIF(EIF) T_LEFTPAREN expr(COND) T_RIGHTPAREN statement(TRUE) elseSingle(ELSE).
{
    A = new (CTXT) AST::ifStmt(COND, TRUE, ELSE);
    A->setLine(TOKEN_LINE(EIF));
}
// elseif series
elseSeries(A) ::=  T_ELSEIF(EIF) T_LEFTPAREN expr(COND) T_RIGHTPAREN statement(TRUE) elseSeries(ELSE).
{
    A = new (CTXT) AST::ifStmt(COND, TRUE, ELSE);
    A->setLine(TOKEN_LINE(EIF));
}

// if
%type ifBlock {AST::ifStmt*}
ifBlock(A) ::= T_IF(IF) T_LEFTPAREN expr(COND) T_RIGHTPAREN statement(TRUE) elseSeries(ELSE).
{
    A = new (CTXT) AST::ifStmt(COND, TRUE, ELSE);
    A->setLine(TOKEN_LINE(IF));
}
ifBlock(A) ::= T_IF(IF) T_LEFTPAREN expr(COND) T_RIGHTPAREN statement(TRUE) elseSingle(ELSE).
{
    A = new (CTXT) AST::ifStmt(COND, TRUE, ELSE);
    A->setLine(TOKEN_LINE(IF));
}

// foreach
%type forEach {AST::forEach*}
// foreach($expr as $val)
forEach(A) ::= T_FOREACH(F) T_LEFTPAREN expr(RVAL) T_AS T_VARIABLE(VAL) T_RIGHTPAREN statement(BODY).
{
    A = new (CTXT) AST::forEach(RVAL, BODY, CTXT, *VAL, false /*by ref*/ );
    A->setLine(TOKEN_LINE(F));
}
// foreach($expr as $key => $val)
forEach(A) ::= T_FOREACH(F) T_LEFTPAREN expr(RVAL) T_AS T_VARIABLE(KEY) T_ARROWKEY T_VARIABLE(VAL) T_RIGHTPAREN statement(BODY).
{
    A = new (CTXT) AST::forEach(RVAL, BODY, CTXT, *VAL, false /*by ref*/, KEY);
    A->setLine(TOKEN_LINE(F));
}
// foreach($expr as &$val)
forEach(A) ::= T_FOREACH(F) T_LEFTPAREN expr(RVAL) T_AS T_AND T_VARIABLE(VAL) T_RIGHTPAREN statement(BODY).
{
    A = new (CTXT) AST::forEach(RVAL, BODY, CTXT, *VAL, true /*by ref*/);
    A->setLine(TOKEN_LINE(F));
}
// foreach($expr as $key => &$val)
forEach(A) ::= T_FOREACH(F) T_LEFTPAREN expr(RVAL) T_AS T_VARIABLE(KEY) T_ARROWKEY T_AND T_VARIABLE(VAL) T_RIGHTPAREN statement(BODY).
{
    A = new (CTXT) AST::forEach(RVAL, BODY, CTXT, *VAL, true /*by ref*/, KEY);
    A->setLine(TOKEN_LINE(F));
}

// for
%type forStmt {AST::forStmt*}
forStmt(A) ::= T_FOR(F) T_LEFTPAREN forExpr(INIT) T_SEMI forExpr(COND) T_SEMI forExpr(INC) T_RIGHTPAREN statement(BODY).
{
    A = new (CTXT) AST::forStmt(CTXT, INIT, COND, INC, BODY);
    A->setLine(TOKEN_LINE(F));
}

%type forExpr {AST::stmt*}
forExpr(A) ::= .
{
    A = NULL;
}
forExpr(A) ::= commaExprList(B).
{
    assert(B->size());
    if (B->size() == 1) {
        A = static_cast<AST::stmt*>( B->at(0) );
    }
    else {
        A = new (CTXT) AST::block(CTXT, B);
    }
    delete B;
}

// do
%type doStmt {AST::doStmt*}
doStmt(A) ::= T_DO statement(BODY) T_WHILE T_LEFTPAREN expr(COND) T_RIGHTPAREN.
{
    A = new (CTXT) AST::doStmt(CTXT, COND, BODY);
    A->setLine(CURRENT_LINE);
}

// while
%type whileStmt {AST::whileStmt*}
whileStmt(A) ::= T_WHILE T_LEFTPAREN expr(COND) T_RIGHTPAREN statement(BODY).
{
    A = new (CTXT) AST::whileStmt(CTXT, COND, BODY);
    A->setLine(CURRENT_LINE);
}

// switch
%type switchStmt {AST::switchStmt*}
switchStmt(A) ::= T_SWITCH T_LEFTPAREN expr(RVAL) T_RIGHTPAREN switchCaseList(CASES).
{
    A = new (CTXT) AST::switchStmt(RVAL, CASES);
    A->setLine(CURRENT_LINE);
}

%type switchCaseList {AST::block*}
switchCaseList(A) ::= T_LEFTCURLY(LC) caseList(CASES) T_RIGHTCURLY(RC).
{
    A = new (CTXT) AST::block(CTXT, CASES);
    A->setLine(TOKEN_LINE(LC), TOKEN_LINE(RC));
    delete CASES;
}
switchCaseList(A) ::= T_LEFTCURLY(LC) T_SEMI caseList(CASES) T_RIGHTCURLY(RC).
{
    A = new (CTXT) AST::block(CTXT, CASES);
    A->setLine(TOKEN_LINE(LC), TOKEN_LINE(RC));
    delete CASES;
}
switchCaseList(A) ::= T_COLON(LC) caseList(CASES) T_ENDSWITCH(RC).
{
    A = new (CTXT) AST::block(CTXT, CASES);
    A->setLine(TOKEN_LINE(LC), TOKEN_LINE(RC));
    delete CASES;
}
switchCaseList(A) ::= T_COLON(LC) T_SEMI caseList(CASES) T_ENDSWITCH(RC).
{
    A = new (CTXT) AST::block(CTXT, CASES);
    A->setLine(TOKEN_LINE(LC), TOKEN_LINE(RC));
    delete CASES;
}

%type caseList {AST::statementList*} //  root nodes here must be switchCase* casted to stmt*
caseList(A) ::= .
{
    A = new AST::statementList();
}
caseList(A) ::= caseList(LIST) T_CASE expr(COND) caseSeparator statement_list(STMTS).
{
    AST::switchCase* c = new (CTXT) AST::switchCase(COND,
                                                    new (CTXT) AST::block(CTXT, STMTS));
    c->setLine(CURRENT_LINE);
    LIST->push_back(static_cast<AST::stmt*>(c));
    delete STMTS;
    A = LIST;
}
caseList(A) ::= caseList(LIST) T_DEFAULT caseSeparator statement_list(STMTS).
{
    AST::switchCase* c = new (CTXT) AST::switchCase(NULL,
                                                     new (CTXT) AST::block(CTXT, STMTS));
    c->setLine(CURRENT_LINE);
    LIST->push_back(static_cast<AST::stmt*>(c));
    delete STMTS;
    A = LIST;
}

caseSeparator ::= T_COLON.
caseSeparator ::= T_SEMI.

/** DECLARATIONS **/

/** STATIC **/
%type staticDecl {AST::staticDecl*}
staticDecl(A) ::= T_STATIC T_VARIABLE(ID).
{
    A = new (CTXT) AST::staticDecl(pSourceRange(++(*ID).begin(), (*ID).end()), CTXT);
    A->setLine(CURRENT_LINE);
}

staticDecl(A) ::= T_STATIC T_VARIABLE(ID) T_ASSIGN literal(DEF).
{
    A = new (CTXT) AST::staticDecl(pSourceRange(++(*ID).begin(), (*ID).end()),
    CTXT, DEF);
    A->setLine(CURRENT_LINE);
}


/** FUNCTION FORMAL PARAMS **/
%type formalParam {AST::formalParam*}
formalParam(A) ::= T_VARIABLE(PARAM).
{
    A = new (CTXT) AST::formalParam(pSourceRange(++(*PARAM).begin(), (*PARAM).end()),
                              CTXT, false/*ref*/);
    A->setLine(TOKEN_LINE(PARAM));
}
formalParam(A) ::= T_AND T_VARIABLE(PARAM).
{
    A = new (CTXT) AST::formalParam(pSourceRange(++(*PARAM).begin(), (*PARAM).end()),
                              CTXT, true/*ref*/);
    A->setLine(TOKEN_LINE(PARAM));
}
formalParam(A) ::= T_VARIABLE(PARAM) T_ASSIGN literal(DEF).
{
    A = new (CTXT) AST::formalParam(pSourceRange(++(*PARAM).begin(), (*PARAM).end()),
                              CTXT, false/*ref*/, DEF);
    A->setLine(TOKEN_LINE(PARAM));
}
formalParam(A) ::= T_AND T_VARIABLE(PARAM) T_ASSIGN literal(DEF).
{
    A = new (CTXT) AST::formalParam(pSourceRange(++(*PARAM).begin(), (*PARAM).end()),
                              CTXT, true/*ref*/, DEF);
    A->setLine(TOKEN_LINE(PARAM));
}


%type formalParamList {AST::formalParamList*}
formalParamList(A) ::= formalParam(PARAM).
{
    A = new AST::formalParamList();
    A->push_back(PARAM);
}
formalParamList(A) ::= formalParam(PARAM) T_COMMA formalParamList(C).
{
    C->push_back(PARAM);
    A = C;
}
formalParamList(A) ::= .
{
    A = new AST::formalParamList();
}

/** FUNCTION DECL **/
%type signature {AST::signature*}
signature(A) ::= T_IDENTIFIER(NAME) T_LEFTPAREN formalParamList(PARAMS) T_RIGHTPAREN.
{
    A = new (CTXT) AST::signature(*NAME, CTXT, PARAMS, false/*ref*/);
    A->setLine(TOKEN_LINE(NAME));
    delete PARAMS;
}
signature(A) ::= T_AND T_IDENTIFIER(NAME) T_LEFTPAREN formalParamList(PARAMS) T_RIGHTPAREN.
{
    A = new (CTXT) AST::signature(*NAME, CTXT, PARAMS, true/*ref*/);
    A->setLine(TOKEN_LINE(NAME));
    delete PARAMS;
}

%type functionDecl {AST::functionDecl*}
functionDecl(A) ::= T_FUNCTION signature(SIG) statementBlock(BODY).
{
    A = new (CTXT) AST::functionDecl(SIG, BODY);
}                    

/****** EXPRESSIONS *********/
%type expr {AST::expr*}
expr(A) ::= literal(B). { A = B; }
expr(A) ::= assignment(B). { A = B; }
expr(A) ::= opAssignment(B). { A = B; }
expr(A) ::= lval(B). { A = B; }
expr(A) ::= functionInvoke(B). { A = B; }
expr(A) ::= constructorInvoke(B). { A = B; }
expr(A) ::= unaryOp(B). { A = B; }
expr(A) ::= binaryOp(B). { A = B; }
expr(A) ::= builtin(B). { A = B; }
expr(A) ::= typeCast(B). { A = B; }
expr(A) ::= preOp(B). { A = B; }
expr(A) ::= postOp(B). { A = B; }
expr(A) ::= T_LEFTPAREN expr(B) T_RIGHTPAREN. { A = B; }

/** BUILTINS **/
%type builtin {AST::builtin*}
// exit
builtin(A) ::= T_EXIT.
{
    A = new (CTXT) AST::builtin(CTXT, AST::builtin::EXIT);
    A->setLine(CURRENT_LINE);
}
builtin(A) ::= T_EXIT T_LEFTPAREN T_RIGHTPAREN.
{
    A = new (CTXT) AST::builtin(CTXT, AST::builtin::EXIT);
    A->setLine(CURRENT_LINE);
}
builtin(A) ::= T_EXIT T_LEFTPAREN expr(RVAL) T_RIGHTPAREN.
{
    AST::expressionList* rval = new AST::expressionList();
    rval->push_back(RVAL);
    A = new (CTXT) AST::builtin(CTXT, AST::builtin::EXIT, rval);
    delete rval;
    A->setLine(CURRENT_LINE);
}
// empty
builtin(A) ::= T_EMPTY T_LEFTPAREN lval(RVAL) T_RIGHTPAREN.
{
    AST::expressionList* rval = new AST::expressionList();
    rval->push_back(RVAL);
    A = new (CTXT) AST::builtin(CTXT, AST::builtin::EMPTY, rval);
    delete rval;
    A->setLine(CURRENT_LINE);
}
// isset
 builtin(A) ::= T_ISSET T_LEFTPAREN commaVarList(VARS) T_RIGHTPAREN.
{
   A = new (CTXT) AST::builtin(CTXT, AST::builtin::ISSET, VARS);
   A->setLine(CURRENT_LINE);
   delete VARS;
}
// unset
builtin(A) ::= T_UNSET T_LEFTPAREN commaVarList(VARS) T_RIGHTPAREN.
{
   A = new (CTXT) AST::builtin(CTXT, AST::builtin::UNSET, VARS);
   A->setLine(CURRENT_LINE);
   delete VARS;
}
// print
builtin(A) ::= T_PRINT expr(RVAL).
{
    AST::expressionList* rval = new AST::expressionList();
    rval->push_back(RVAL);
    A = new (CTXT) AST::builtin(CTXT, AST::builtin::PRINT, rval);
    delete rval;
    A->setLine(CURRENT_LINE);
}

%type commaVarList {AST::expressionList*}
commaVarList(A) ::= lval(VAR).
{
    A = new AST::expressionList();
    A->push_back(VAR);
}
commaVarList(A) ::= commaVarList(LIST) T_COMMA lval(VAR).
{
    LIST->push_back(VAR);
    A = LIST;
}

%type commaExprList {AST::expressionList*}
commaExprList(A) ::= expr(E).
{
    A = new AST::expressionList();
    A->push_back(E);
}
commaExprList(A) ::= commaExprList(LIST) T_COMMA expr(E).
{
    LIST->push_back(E);
    A = LIST;
}

/** TYPECASTS **/
%type typeCast {AST::typeCast*}
typeCast(A) ::= T_FLOAT_CAST expr(rVal).
{
    A = new (CTXT) AST::typeCast(AST::typeCast::REAL, rVal);
    A->setLine(CURRENT_LINE);
}
typeCast(A) ::= T_INT_CAST expr(rVal).
{
    A = new (CTXT) AST::typeCast(AST::typeCast::INT, rVal);
    A->setLine(CURRENT_LINE);
}
typeCast(A) ::= T_STRING_CAST expr(rVal).
{
    A = new (CTXT) AST::typeCast(AST::typeCast::STRING, rVal);
    A->setLine(CURRENT_LINE);
}
typeCast(A) ::= T_BINARY_CAST expr(rVal).
{
    A = new (CTXT) AST::typeCast(AST::typeCast::BINARY, rVal);
    A->setLine(CURRENT_LINE);
}
typeCast(A) ::= T_UNICODE_CAST expr(rVal).
{
    A = new (CTXT) AST::typeCast(AST::typeCast::UNICODE, rVal);
    A->setLine(CURRENT_LINE);
}
typeCast(A) ::= T_ARRAY_CAST expr(rVal).
{
    A = new (CTXT) AST::typeCast(AST::typeCast::ARRAY, rVal);
    A->setLine(CURRENT_LINE);
}
typeCast(A) ::= T_OBJECT_CAST expr(rVal).
{
    A = new (CTXT) AST::typeCast(AST::typeCast::OBJECT, rVal);
    A->setLine(CURRENT_LINE);
}
typeCast(A) ::= T_UNSET_CAST expr(rVal).
{
    A = new (CTXT) AST::typeCast(AST::typeCast::UNSET, rVal);
    A->setLine(CURRENT_LINE);
}
typeCast(A) ::= T_BOOL_CAST expr(rVal).
{
    A = new (CTXT) AST::typeCast(AST::typeCast::BOOL, rVal);
    A->setLine(CURRENT_LINE);
}


/** LITERALS **/
%type literal {AST::literalExpr*}

// literal string
literal(A) ::= T_SQ_STRING(B).
{
  A = extractLiteralString(B, pMod, true);
  A->setLine(CURRENT_LINE);
}
literal(A) ::= T_DQ_STRING(B).
{
  A = extractLiteralString(B, pMod, false);
  A->setLine(CURRENT_LINE);
}

// literal integers (decimal)
literal(A) ::= T_LNUMBER(B).
{
    A = new (CTXT) AST::literalInt(*B);
    A->setLine(CURRENT_LINE);
}

// literal integers (float)
literal(A) ::= T_DNUMBER(B).
{
    A = new (CTXT) AST::literalFloat(*B);
    A->setLine(CURRENT_LINE);    
}

// literal identifier: null, true, false or string
literal(A) ::= T_IDENTIFIER(B).
{
    // case insensitive checks
    pSourceString ciTmp((*B).begin(), (*B).end());
    transform(ciTmp.begin(), ciTmp.end(), ciTmp.begin(), toupper);
    if (ciTmp == "NULL") {
        A = new (CTXT) AST::literalNull();
    }
    else if (ciTmp == "TRUE") {
        A = new (CTXT) AST::literalBool(true);
    }
    else if (ciTmp == "FALSE") {
        A = new (CTXT) AST::literalBool(false);
    }
    else {
        // default to normal string
        A = new (CTXT) AST::literalString(*B);
    }
    A->setLine(CURRENT_LINE);
}

/** LITERAL ARRAY ITEMS **/
%type arrayItemList {AST::arrayList*}
arrayItemList(A) ::= arrayItem(B).
{
    A = new AST::arrayList();
    A->push_back(*B); // copy item into vector
    // note no delete here because it's in ast pool
}
arrayItemList(A) ::= arrayItem(B) T_COMMA arrayItemList(C).
{
    C->push_back(*B); // copy item into vector
    A = C;
    // note no delete here because it's in ast pool
}
arrayItemList(A) ::= .
{
    A = new AST::arrayList();
}

%type arrayItem {AST::arrayItem*}
arrayItem(A) ::= expr(B).
{
    A = new (CTXT) AST::arrayItem(NULL, B, false);
}
arrayItem(A) ::= T_AND expr(B).
{
    A = new (CTXT) AST::arrayItem(NULL, B, true);
}
arrayItem(A) ::= expr(KEY) T_ARROWKEY expr(VAL).
{
    A = new (CTXT) AST::arrayItem(KEY, VAL, false);
}
arrayItem(A) ::= expr(KEY) T_ARROWKEY T_AND expr(VAL).
{
    A = new (CTXT) AST::arrayItem(KEY, VAL, true);
}

// literal array
literal(A) ::= T_ARRAY(ARY) T_LEFTPAREN arrayItemList(B) T_RIGHTPAREN.
{
    A = new (CTXT) AST::literalArray(B);
    A->setLine(TOKEN_LINE(ARY));
    delete B; // deletes the vector, NOT the exprs in it!
}

/** UNARY OPERATORS **/
%type unaryOp {AST::unaryOp*}
unaryOp(A) ::= T_PLUS expr(R).
{
    A = new (CTXT) AST::unaryOp(R, AST::unaryOp::POSITIVE);
    A->setLine(CURRENT_LINE);
}
unaryOp(A) ::= T_MINUS expr(R).
{
    A = new (CTXT) AST::unaryOp(R, AST::unaryOp::NEGATIVE);
    A->setLine(CURRENT_LINE);
}
unaryOp(A) ::= T_BOOLEAN_NOT expr(R).
{
    A = new (CTXT) AST::unaryOp(R, AST::unaryOp::LOGICALNOT);
    A->setLine(CURRENT_LINE);
}

/** BINARY OPERATORS **/
%type binaryOp {AST::binaryOp*}
binaryOp(A) ::= expr(L) T_DOT expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::CONCAT);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_BOOLEAN_AND expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::BOOLEAN_AND);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_BOOLEAN_AND_LIT expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::BOOLEAN_AND);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_BOOLEAN_OR expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::BOOLEAN_OR);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_BOOLEAN_OR_LIT expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::BOOLEAN_OR);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_BOOLEAN_XOR_LIT expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::BOOLEAN_XOR);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_DIV expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::DIV);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_MOD expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::MOD);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_MULT expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::MULT);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_PLUS expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::ADD);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_MINUS expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::SUB);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_GREATER_THAN expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::GREATER_THAN);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_LESS_THAN expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::LESS_THAN);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_GREATER_OR_EQUAL expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::GREATER_OR_EQUAL);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_LESS_OR_EQUAL expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::LESS_OR_EQUAL);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_EQUAL expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::EQUAL);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_NOT_EQUAL expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::NOT_EQUAL);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_IDENTICAL expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::IDENTICAL);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_NOT_IDENTICAL expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::NOT_IDENTICAL);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_CARET expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::BIT_XOR);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_PIPE expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::BIT_OR);
    A->setLine(CURRENT_LINE);
}
binaryOp(A) ::= expr(L) T_AND expr(R).
{
    A = new (CTXT) AST::binaryOp(L, R, AST::binaryOp::BIT_AND);
    A->setLine(CURRENT_LINE);
}

/** PRE/POST OP **/
%type preOp {AST::preOp*}
preOp(A) ::= T_INC lval(R).
{
    A = new (CTXT) AST::preOp(R, AST::preOp::INC);
    A->setLine(CURRENT_LINE);
}
preOp(A) ::= T_DEC lval(R).
{
    A = new (CTXT) AST::preOp(R, AST::preOp::DEC);
    A->setLine(CURRENT_LINE);
}
%type postOp {AST::postOp*}
postOp(A) ::= lval(R) T_INC.
{
    A = new (CTXT) AST::postOp(R, AST::postOp::INC);
    A->setLine(CURRENT_LINE);
}
postOp(A) ::= lval(R) T_DEC.
{
    A = new (CTXT) AST::postOp(R, AST::postOp::DEC);
    A->setLine(CURRENT_LINE);
}

/** ASSIGNMENT **/
%type assignment {AST::assignment*}
assignment(A) ::= lval(L) T_ASSIGN(EQ_SIGN) expr(R).
{
    A = new (CTXT) AST::assignment(L, R, false);
    A->setLine(TOKEN_LINE(EQ_SIGN));
}
assignment(A) ::= lval(L) T_ASSIGN T_AND(EQ_SIGN) lval(R).
{
    A = new (CTXT) AST::assignment(L, R, true);
    A->setLine(TOKEN_LINE(EQ_SIGN));
}

%type opAssignment {AST::opAssignment*}
opAssignment(A) ::= lval(L) T_AND_EQUAL(EQ_SIGN) expr(R).
{
    A = new (CTXT) AST::opAssignment(L, R, AST::opAssignment::AND);
    A->setLine(TOKEN_LINE(EQ_SIGN));
}
opAssignment(A) ::= lval(L) T_OR_EQUAL(EQ_SIGN) expr(R).
{
    A = new (CTXT) AST::opAssignment(L, R, AST::opAssignment::OR);
    A->setLine(TOKEN_LINE(EQ_SIGN));
}
opAssignment(A) ::= lval(L) T_XOR_EQUAL(EQ_SIGN) expr(R).
{
    A = new (CTXT) AST::opAssignment(L, R, AST::opAssignment::XOR);
    A->setLine(TOKEN_LINE(EQ_SIGN));
}
opAssignment(A) ::= lval(L) T_CONCAT_EQUAL(OP) expr(R).
{
    A = new (CTXT) AST::opAssignment(L, R, AST::opAssignment::CONCAT);
    A->setLine(TOKEN_LINE(OP));
}
opAssignment(A) ::= lval(L) T_DIV_EQUAL(OP) expr(R).
{
    A = new (CTXT) AST::opAssignment(L, R, AST::opAssignment::DIV);
    A->setLine(TOKEN_LINE(OP));
}
opAssignment(A) ::= lval(L) T_MUL_EQUAL(OP) expr(R).
{
    A = new (CTXT) AST::opAssignment(L, R, AST::opAssignment::MULT);
    A->setLine(TOKEN_LINE(OP));
}
opAssignment(A) ::= lval(L) T_PLUS_EQUAL(OP) expr(R).
{
    A = new (CTXT) AST::opAssignment(L, R, AST::opAssignment::ADD);
    A->setLine(TOKEN_LINE(OP));
}
opAssignment(A) ::= lval(L) T_MINUS_EQUAL(OP) expr(R).
{
    A = new (CTXT) AST::opAssignment(L, R, AST::opAssignment::SUB);
    A->setLine(TOKEN_LINE(OP));
}
opAssignment(A) ::= lval(L) T_MOD_EQUAL(OP) expr(R).
{
    A = new (CTXT) AST::opAssignment(L, R, AST::opAssignment::MOD);
    A->setLine(TOKEN_LINE(OP));
}


/** LVALS **/
%type lval {AST::expr*}
lval(A) ::= variable_lVal(B). { A = B; }
lval(A) ::= array_lVal(B). { A = B; }

%type variable_lVal {AST::var*}
// $foo
variable_lVal(A) ::= T_VARIABLE(B).
{
    // strip $
    A = new (CTXT) AST::var(pSourceRange(++(*B).begin(), (*B).end()), CTXT);
    A->setLine(CURRENT_LINE);
}
// $foo->bar
variable_lVal(A) ::= lval(TARGET) T_CLASSDEREF T_IDENTIFIER(ID).
{
    A = new (CTXT) AST::var(pSourceRange(++(*ID).begin(), (*ID).end()), CTXT, TARGET);
    A->setLine(CURRENT_LINE);
}
// $foo[]
%type array_lVal {AST::var*}
array_lVal(A) ::= T_VARIABLE(B) arrayIndices(C).
{
    // strip $
    A = new (CTXT) AST::var(pSourceRange(++(*B).begin(), (*B).end()), CTXT, C);
    A->setLine(CURRENT_LINE);
    delete C;
}
// $foo->bar[]
variable_lVal(A) ::= lval(TARGET) T_CLASSDEREF T_IDENTIFIER(ID) arrayIndices(INDICES).
{
    A = new (CTXT) AST::var(pSourceRange(++(*ID).begin(), (*ID).end()), CTXT, INDICES, TARGET);
    A->setLine(CURRENT_LINE);
}

/** ARGLIST **/
%type argList {AST::expressionList*}
argList(A) ::= expr(B).
{
    A = new AST::expressionList();
    A->push_back(B);
}
argList(A) ::= expr(B) T_COMMA argList(C).
{
    C->push_back(B);
    A = C;
}
argList(A) ::= .
{
    A = new AST::expressionList();
}

/** ARRAY INDICES **/
%type arrayIndices {AST::expressionList*}
arrayIndices(A) ::= T_LEFTSQUARE expr(B) T_RIGHTSQUARE.
{
    A = new AST::expressionList();
    A->push_back(B);
}
arrayIndices(A) ::= arrayIndices(B) T_LEFTSQUARE expr(C) T_RIGHTSQUARE.
{
    B->push_back(C);
    A = B;
}
arrayIndices(A) ::= T_LEFTSQUARE T_RIGHTSQUARE.
{
    A = new AST::expressionList();    
    AST::stmt* noop = new (CTXT) AST::emptyStmt();
    A->push_back(static_cast<AST::expr*>(noop));
}
arrayIndices(A) ::= arrayIndices(B) T_LEFTSQUARE T_RIGHTSQUARE.
{
    AST::stmt* noop = new (CTXT) AST::emptyStmt();
    B->push_back(static_cast<AST::expr*>(noop));
    A = B;
}

/** FUNCTION/METHOD INVOKE **/
%type functionInvoke {AST::functionInvoke*}
// foo()
functionInvoke(A) ::= T_IDENTIFIER(ID) T_LEFTPAREN argList(ARGS) T_RIGHTPAREN.
{
    A = new (CTXT) AST::functionInvoke(*ID, // f name
                                                  CTXT,
                                                  ARGS  // expression list: arguments, copied
                                                  );
    A->setLine(CURRENT_LINE);
    delete ARGS;
}
// $foo->bar()
functionInvoke(A) ::= lval(LVAL) T_CLASSDEREF T_IDENTIFIER(ID) T_LEFTPAREN argList(ARGS) T_RIGHTPAREN.
{
    A = new (CTXT) AST::functionInvoke(*ID, // f name
                                                  CTXT,
                                                  ARGS,  // expression list: arguments, copied
                                                  LVAL
                                                  );
    A->setLine(CURRENT_LINE);
    delete ARGS;
}


/** CONSTRUCTOR INVOKE **/
%type constructorInvoke {AST::functionInvoke*}
constructorInvoke(A) ::= T_NEW T_IDENTIFIER(B) T_LEFTPAREN argList(C) T_RIGHTPAREN.
{
    A = new (CTXT) AST::functionInvoke(*B, // f name
                                                  CTXT,
                                                  C  // expression list: arguments, copied
                                                  );
    A->setLine(CURRENT_LINE);
    delete C;
}

