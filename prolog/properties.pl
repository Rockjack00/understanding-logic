%%% Properties logic
:- consult("engines-and-modelets.pl").

%% Types

% A property of some modelet.
%
% property(?Property).
:- dynamic property/1.
:- multifile property/1.

% A requirement of some template.
%
% requirement(?Requirement).
:- dynamic requirement/1.
:- multifile requirement/1.


%% Predicates

% A property has some numerical value.
%
% has_value(+Property, +Value).
:- dynamic has_value/2.
:- multifile has_value/2.

% A property has some datatype.
%   - in tff this is implemented as a function instead of a predicate.
%
% datatype_of_property(?Property, ?Datatype).
:- dynamic datatype_of_property/2.
:- multifile datatype_of_property/2.

% A requirement has some datatype.
%   - in tff this is implemented as a function instead of a predicate.
%
% datatype_of_requirement(?Requirement, ?Datatype).
:- dynamic datatype_of_requirement/2.
:- multifile datatype_of_requirement/2.

% A specific required property value is acceptable.
%
% is_permissible(+Requirement, +Value)
% FIXME: implement is_permissible

% A modelet has some property.
% TODO: this assumes that the engine was exertable...
%
% modelet_has_property(?Modelet, ?Property).
modelet_has_property(M, P) :-
    modelet(M), property(P),
    exert(E, _, M), engine_imparts_output_property(E, P).

% An engine has some property.
% TODO: I don't think this is actually used...
%
% engine_has_property(?Engine, ?Property).
% FIXME: implement engine_has_property??

% An engine imparts some property on its output modelets.
%
% output_property_of_engine(?Engine, ?Property).
:- dynamic output_property_of_engine/2.
:- multifile output_property_of_engine/2.

% A property requirement is part of a template.
%
% is_part_of(?Requirement, ?Template)
:- dynamic is_part_of/2.
:- multifile is_part_of/2.

% A modelet and temlate are formally equivalent if all of the specifications match.
%
% formally_equivalent(?Template, ?Modelet)
formally_equivalent(T, M) :-
    template(T), modelet(M),
    (template_formalism_requirement(T, F) -> formalism_of_modelet(M, F); true), 
    (template_has_concept_requirement(T, C) -> modelet_models_concept(M, C); true), 
    (template_has_representation_class_requirement(T, R) -> modelet_has_representation_class(M, R); true), 
    (template_has_creator_requirement(T, E) -> modelet_has_creator(M, E); true). 

% Property has correct data format for a requirement and is permissible
%
% property_meets_requirement(?Property, ?Requirement)
property_meets_requirement(P, R) :-
    property(P), requirement(R),
    datatype_of_property(R, D), datatype_of_requirement(R, D), 
    has_value(P, V), is_permissible(R, V).

% Modelet meets a requirement if it has a matching property.
%
% modelet_meets_requirement(?Modelet, ?Requirement)
modelet_meets_requirement(M, R) :-
    modelet(M), requirement(R),
    modelet_has_property(M, P), property_meets_requirement(P, R).

% Modelet matches a template.
%
% inputs_match(?Modelet, ?Template)
inputs_match(M, T) :-
    modelet(M), template(T),
    formally_equivalent(T, M),
    forall(is_part_of(R, T), modelet_meets_requirement(M, R)).

% Modelet set matches with a template set.
%
% interfaces_match(?Modelet_set, ?Template_set)
interfaces_match(MS, TS) :-
    modelet_set(MS), template_set(TS),
    forall(is_in_template_set(T, TS),
        (
            is_in_modelet_set(M, MS), inputs_match(M, T)
        )
    ).

% A modelet set can be exerted by an engine (it contains modelets matching all
% of the required inputs).
%
% exertable(?Engine, ?Modelet_set)
exertable(E, MS) :-
    engine(E), modelet_set(MS),
    interface_of(E, TS), interfaces_match(MS, TS).

