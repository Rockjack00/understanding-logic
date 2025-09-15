%%% Understanding Calculus
:- consult("properties.pl").


%% Types


%% Predicates

% The act of exerting an engine on a modelet set,resulting in a modelet in a
% defined state of knowledge, resulting in the addition of the output modelet
% to that state of knowledge
%
% exertion(?Engine, +In_Modelet_set, -Out_modelet_set)
% exertion(E, MS, [M|MS]) :-
%     engine(E), modelet_set(MS),
%     exertable(E, MS), exert(E, MS, M).

%% Functions

% Idea: dynamically create modelet sets and modelets, to prove existence of some
% modelet set containing the target modelet.

% sketch:
% Base Case: MS is empty or all ground (they exist)
% modelet_set([]).
% modelet_set([modelet_a, modelet_b]).

% Inductive step: A new modelet set can be created by exerting an engine.
% modelet_set([Mnew|MS]) :-
%     modelet_set(MS),
%     exertable(E, MS),
%     uuid(ID), sub_atom(ID, 0, 8, _, Suffix), atom_concat(E, Suffix, Mnew), % create a new modelet from the engine
%     assert((modelet(Mnew))), % witnesses the exertion of E on MSin
%     assert((exert(E, MS, Mnew))).

% Therefore: A modelet set containing X exists (and it contains the names of all
% the exerted engines and the order from tail to head in which they were exerted)
% - AND: it does not mix different chains of exertions together...
% ?- modelet_set(MS), is_in_modelet_set(M, MS), inputs_match(M, Tdesired).



% Idea: same as above but create parents instead of children.
% NOTE: this is more directed than the previous but requires using only partial
% knowledge (exerting an engine may only fulfill some of the desired properties).
% This knowledge asymmetry is the fundamental problem to overcome

% Modelets as collection (set) of properties
% Templates as a collection (set) of properties
% Engines are transformations between sets of sets of properties
% to a set of properties ==> need to think about engines producing
% sets of things?

% Properties that are "not specifically desired" are "side effects"
% which are bonus understanding?

% Process:
% 1) See if template is understood (already in KB)
% 2) See if it can be understood by executing an engine with already understood inputs
% 3) Use non-understood input templates as new goals.



% sketch:
% Base Case: Engine is exertable on initial MS
% exert(E, ius, M) :-
%     engine(E), modelet(M)
%     exertable(E, ius). % ! (I think this is the place for a red cut)
% 
% Inductive step: A new modelet set is needed when exerting an engine.
% exert(E, MS, M) :-
%     engine(E), modelet(M),
% if
%     \+ exertable(E, MS),
% then
%     interface_of(E, TS),
%     uuid(MSnew), assert((modelet_set(MSnew))), % create a new modelet set.
%     assert((is_in_modelet_set(Mx, MSnew) :- is_in_modelet_set(Mx, MS))), % new starting set plus created ones
%     assert((is_in_modelet_set(MSNew, M)) % target modelet exists in new MS
%     foreach((is_in_template_set(T, TS), \+ match(T, MS)),
%         (
%             assert((goal_template(T))),
%         )
%     )
% 
% Therefore: When there is a MS to produce all goal modelets, then
% the goal is also exertable.
% ?- goal_template(Tdesired), forall(goal_template(T),
%     (
%       (is_in_modelet_set(MS, M), inputs_match(M, T));
%       (exert(E, MS, M), inputs_match(M, T))
%     )
% ).

generates_new_unique_chain(E, MS) :-
    engine(E), modelet_set(MS),
    exertable(E, MS), \+ (exert(E, MSpar, _), subset(MSpar, MS)).

understand(T, MS) :-
    template(T), modelet_set(MS),
    ( 
        is_in_modelet_set(M, MSany), inputs_match(M, T) 
    -> 
        MS = MSany
    ;
        recur_understand(),
        understand(T, MS)
    ).

recur_understand() :-
    generates_new_unique_chain(E, MS),
    uuid(ID), sub_atom(ID, 0, 8, _, Suffix), atom_concat(E, Suffix, Mnew), 
    assert((exert(E, MS, Mnew))).
