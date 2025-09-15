%%% Engines and modelets
:- consult("fundamental-concepts.pl").


%% Types

% Something that executes a cognitive function using modelets.
% Currently an engine takes a set of modelets as input and produces a single
% modelet as output.
%
% engine(?Engine)
:- dynamic engine/1.
:- multifile engine/1.

% A portion of a model that is communicated between CoreSense modules.
%
% modelet(?Modelet).
:- dynamic modelet/1.
:- multifile modelet/1.
modelet(M) :- 
    exert(_, _, M).

% A set of modelets.
%
% modelet_set(?Modelet_set).
:- dynamic modelet_set/1.
:- multifile modelet_set/1.
modelet_set([M|MS]) :- 
    exert(_, MS, M).

% A description of an input to an engine
%
% template(?Template)
:- dynamic template/1.
:- multifile template/1.

% A set of templates.
%
% template_set(?Template_set).
:- dynamic template_set/1.
:- multifile template_set/1.


%% Predicates

% The formalism of the output modelet produced by some engine.
% TODO: rename this to 'is_output_modelet_formalism' to match the naming scheme.
%   - in tff this is implemented as a function instead of a predicate.
%
% output_modelet_formalism(?Engine, ?Formalism)
:- dynamic output_modelet_formalism/2.
:- multifile output_modelet_formalism/2.

% The concept of the output modelet produced by some engine.
%
% is_output_modelet_concept(?Engine, ?Concept)
:- dynamic is_output_modelet_concept/2.
:- multifile is_output_modelet_concept/2.

% The representation class of the output modelet produced by some engine.
% Engines can impart processing semantics unto their output modelets.
%
% is_output_modelet_representation_class(?Engine, ?Representation_class)
:- dynamic is_output_modelet_representation_class/2.
:- multifile is_output_modelet_representation_class/2.

% Specifies if a modelet is a member of a particular modelet set.
%
% is_in_modelet_set(?Modelet, ?Modelet_set)
:- dynamic is_in_modelet_set/2.
:- multifile is_in_modelet_set/2.
is_in_modelet_set(M, MS) :-
    modelet(M), modelet_set(MS),
    member(M, MS).

% The formalism of a modelet.
% TODO: rename this to 'is_formalism_of_modelet' to match the naming scheme.
%   - in tff this is implemented as a function instead of a predicate.
%
% formalism_of_modelet(?Modelet, ?Formalism)
formalism_of_modelet(M, F) :-
    modelet(M), formalism(F),
    exert(E, _, M), output_modelet_formalism(E, F).

% The modelet_set that was used to create a modelet.
% i.e. the modelet_set was input to some engine that produced the modelet.
%
% parents_of_modelet(?Modelet, ?Modelet_set)
parents_of_modelet(M, MS) :-
    modelet(M), modelet_set(MS),
    exert(_, MS, M).

% The engine that was used to create a modelet.
%
% modelet_has_creator(?Modelet, ?Engine)
modelet_has_creator(M, E) :-
    modelet(M), engine(E),
    exert(E, _, M).

% The concept that is associated with a modelet.
%
% modelet_models_concept(?Modelet, ?Concept)
modelet_models_concept(M, C) :-
    modelet(M), concept(C),
    exert(E, _, M), is_output_modelet_concept(E, C).

% The representation class that is associated with a modelet.
%
% modelet_has_representation_class(?Modelet, ?Representation_class)
modelet_has_representation_class(M, R) :-
    modelet(M), representation_class(R),
    exert(E, _, M), is_output_modelet_representation_class(E, R).

% The formalism requirement of some template.
% TODO: rename this to 'template_has_formalism_requriement' to match the naming scheme.
%   - in tff this is implemented as a function instead of a predicate.
%
% template_formalism_requriement(?Template, ?Formalism)
:- dynamic template_formalism_requirement/2.
:- multifile template_formalism_requirement/2.
:- discontiguous template_formalism_requirement/2.

% The creator (Engine that created a modelet) requirement of some template.
%
% template_has_creator_requirement(?Template, ?Creator)
:- dynamic template_has_creator_requirement/2.
:- multifile template_has_creator_requirement/2.
:- discontiguous template_has_creator_requirement/2.

% The concept requirement of some template.
%
% template_has_concept_requirement(?Template, ?Concept)
:- dynamic template_has_concept_requirement/2.
:- multifile template_has_concept_requirement/2.
:- discontiguous template_has_concept_requirement/2.

% The representation_class requirement of some template.
%
% template_has_representation_class_requirement(?Template, ?Representation_class)
:- dynamic template_has_representation_class_requirement/2.
:- multifile template_has_representation_class_requirement/2.
:- discontiguous template_has_representation_class_requirement/2.

% Specifies if a template is a member of a particular modelet set.
%
% is_in_template_set(?Template, ?Template_set)
:- dynamic is_in_template_set/2.
:- multifile is_in_template_set/2.
:- discontiguous is_in_template_set/2.

% Engine has the interface defined by some template set.
%
% interface_of(?Engine, ?Template_set)
:- dynamic interface_of/2.
:- multifile interface_of/2.
:- discontiguous interface_of/2.


%% Individuals

% The empty set - is_in_modelet_set(M, empty_ms) always fails.
modelet_set([]).


%% Functions

% Exertion of an engine on a modelet set produces a modelet.
%
% exert(?Engine, ?Modelet_set, ?Modelet)
:- dynamic exert/3.
