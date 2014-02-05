/*-------------------------------------------------------------------------*
 * GNU Prolog                                                              *
 *                                                                         *
 * Part  : Prolog buit-in predicates                                       *
 * File  : assert.pl                                                       *
 * Descr.: dynamic predicate management                                    *
 * Author: Daniel Diaz                                                     *
 *                                                                         *
 * Copyright (C) 1999-2014 Daniel Diaz                                     *
 *                                                                         *
 * This file is part of GNU Prolog                                         *
 *                                                                         *
 * GNU Prolog is free software: you can redistribute it and/or             *
 * modify it under the terms of either:                                    *
 *                                                                         *
 *   - the GNU Lesser General Public License as published by the Free      *
 *     Software Foundation; either version 3 of the License, or (at your   *
 *     option) any later version.                                          *
 *                                                                         *
 * or                                                                      *
 *                                                                         *
 *   - the GNU General Public License as published by the Free             *
 *     Software Foundation; either version 2 of the License, or (at your   *
 *     option) any later version.                                          *
 *                                                                         *
 * or both in parallel, as here.                                           *
 *                                                                         *
 * GNU Prolog is distributed in the hope that it will be useful,           *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU       *
 * General Public License for more details.                                *
 *                                                                         *
 * You should have received copies of the GNU General Public License and   *
 * the GNU Lesser General Public License along with this program.  If      *
 * not, see http://www.gnu.org/licenses/.                                  *
 *-------------------------------------------------------------------------*/


:-	built_in.

'$use_assert'.

:- meta_predicate(asserta(:)).
:- meta_predicate(assertz(:)).

asserta(C) :-
	set_bip_name(asserta, 1),
	'$assert'(C, 1, 1, '').




assertz(C) :-
	set_bip_name(assertz, 1),
	'$assert'(C, 0, 1, '').



				% also called by consult
'$assert'(C, Asserta, CheckPerm, FileName) :-
	'$call_c'('Pl_Assert_4'(C, Asserta, CheckPerm, FileName)).



:- meta_predicate(retract(:)).

retract(C) :-
	set_bip_name(retract, 1),
	'$call_c_test'('Pl_Retract_1'(C)).


:- meta_predicate(retractall(:)).

retractall(H) :-% non-det: CP must not be changed (no env) call_c must be alone (inline)
	set_bip_name(retractall, 1), %inline is OK
	'$call_c'('Pl_Retractall_1'(H)), %inline is OK
	fail.

retractall(_).




:- meta_predicate(clause(:, ?)).

clause(H, B) :-
	set_bip_name(clause, 2),
	'$check_head'(H),
	'$clause'(H, B, true).


'$clause'(H, B, CheckPublic) :-	% non-det: CP must not be changed (no env) call_c must be alone (inline)
	'$call_c_test'('Pl_Clause_3'(H, B, CheckPublic)).

/* OLD CODE
'$retract_last_found' :-
	'$call_c'('Pl_Retract_Last_Found_0').

'$instance_for_setarg'(H, B) :-
	'$call_c_test'('Pl_Clause_3'(H, B, 0)).

'$setarg_in_last_found'(ArgNo, NewValue) :-
	'$call_c'('Pl_Setarg_Of_Last_Found_2'(ArgNo, NewValue)).
*/

:- meta_predicate(abolish(:)).

abolish(PI) :-
	set_bip_name(abolish, 1),
	'$call_c'('Pl_Abolish_1'(PI)).




'$scan_dyn_test_alt' :-             % used by C code to create a choice-point
	'$call_c_test'('Pl_Scan_Dynamic_Pred_Alt_0').

'$scan_dyn_fail_alt' :-             % used by C code to create a choice-point
	'$call_c'('Pl_Scan_Dynamic_Pred_Alt_0'),
	fail.

'$scan_dyn_jump_alt' :-             % used by C code to create a choice-point
	'$call_c_jump'('Pl_Scan_Dynamic_Pred_Alt_0').
