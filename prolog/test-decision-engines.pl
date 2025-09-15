%%% Description of Decision Engines
:- consult("engines-and-modelets.pl").
% TODO: shorten all of the expressions for each kind of engine

%% Concepts
concept(alternative_array).
concept(cue_array).
concept(assessment_matrix).
concept(evaluation).
concept(weak_ordering).
concept(decision).

 
%% Formalisms
formalism(alternative_array_msg).
formalism(cue_array_msg).
formalism(assessment_matrix_msg).
formalism(evaluation_msg).
formalism(weak_ordering_msg).
formalism(decision_msg).

 
%% Representation Classes
representation_class(choice_set).
representation_class(choice).

 
%% Templates
template(choice_set_template).
template_has_concept_requirement(choice_set_template, alternative_array).
template_formalism_requirement(choice_set_template, alternative_array_msg).
template_has_representation_class_requirement(choice_set_template, choice_set).

template(cue_array_template).
template_has_concept_requirement(cue_array_template, cue_array).
template_formalism_requirement(cue_array_template, cue_array_msg).

template(assessment_matrix_template).
template_has_concept_requirement(assessment_matrix_template, assessment_matrix).
template_formalism_requirement(assessment_matrix_template, assessment_matrix_msg).

template(evaluation_template).
template_has_concept_requirement(evaluation_template, evaluation).
template_formalism_requirement(evaluation_template, evaluation_msg).

template(weak_ordering_template).
template_has_concept_requirement(weak_ordering_template, weak_ordering).
template_formalism_requirement(weak_ordering_template, weak_ordering_msg).

template(choice_template).
template_has_concept_requirement(choice_template, alternative_array).
template_formalism_requirement(choice_template, alternative_array_msg).
template_has_representation_class_requirement(choice_template, choice).


%% Engines and Template Sets
template_set(empty_template_set). % No inputs required
% TODO: switch these for lists
% empty_template_set = []

% Update Alternatives
engine(update_alternatives_elim_engine).
output_modelet_formalism(update_alternatives_elim_engine, alternative_array_msg).
is_output_modelet_concept(update_alternatives_elim_engine, alternative_array).
is_output_modelet_representation_class(update_alternatives_elim_engine, choice_set).
interface_of(update_alternatives_elim_engine, empty_template_set).

% Update Cues
engine(update_cues_iter_one_engine).
output_modelet_formalism(update_cues_iter_one_engine, cue_array_msg).
is_output_modelet_concept(update_cues_iter_one_engine, cue_array).
interface_of(update_cues_iter_one_engine, empty_template_set).

engine(update_cues_take_the_best_engine).
output_modelet_formalism(update_cues_take_the_best_engine, cue_array_msg).
is_output_modelet_concept(update_cues_take_the_best_engine, cue_array).
interface_of(update_cues_take_the_best_engine, empty_template_set).

% Assess
template_set(assess_template_set).
is_in_template_set(choice_set_template, assess_template_set).
is_in_template_set(cue_array_template, assess_template_set).
% TODO: switch these for lists
% assess_template_set = [choice_set_template, cue_array_template]

engine(assess_engine).
output_modelet_formalism(assess_engine, assessment_matrix_msg).
is_output_modelet_concept(assess_engine, assessment_matrix).
interface_of(assess_engine, assess_template_set).

% Aggregate
template_set(aggregate_template_set).
is_in_template_set(assessment_matrix_template, aggregate_template_set).
% TODO: switch these for lists
% aggregate_template_set = [assessment_matrix_template]

engine(aggregate_preferences_engine).
output_modelet_formalism(aggregate_preferences_engine, evaluation_msg).
is_output_modelet_concept(aggregate_preferences_engine, evaluation).
interface_of(aggregate_preferences_engine, aggregate_template_set).

engine(aggregate_utility_boolean_engine).
output_modelet_formalism(aggregate_utility_boolean_engine, evaluation_msg).
is_output_modelet_concept(aggregate_utility_boolean_engine, evaluation).
interface_of(aggregate_utility_boolean_engine, aggregate_template_set).

engine(aggregate_utility_signed_engine).
output_modelet_formalism(aggregate_utility_signed_engine, evaluation_msg).
is_output_modelet_concept(aggregate_utility_signed_engine, evaluation).
interface_of(aggregate_utility_signed_engine, aggregate_template_set).

engine(aggregate_utility_sum_engine).
output_modelet_formalism(aggregate_utility_sum_engine, evaluation_msg).
is_output_modelet_concept(aggregate_utility_sum_engine, evaluation).
interface_of(aggregate_utility_sum_engine, aggregate_template_set).

% engine(aggregate_multi_value_utility_engine).
% output_modelet_formalism(aggregate_multi_value_utility_engine, evaluation_msg).
% is_output_modelet_concept(aggregate_multi_value_utility_engine, evluation_matrix).
% interface_of(aggregate_multi_value_utility_engine, aggregate_template_set).

% Order
template_set(order_template_set).
is_in_template_set(evaluation_template, order_template_set).
% TODO: switch these for lists
% order_template_set = [evaluation_template]

engine(order_condorcet_engine).
output_modelet_formalism(order_condorcet_engine, weak_ordering_msg).
is_output_modelet_concept(order_condorcet_engine, weak_ordering).
interface_of(order_condorcet_engine, order_template_set).

engine(order_dominating_engine).
output_modelet_formalism(order_dominating_engine, weak_ordering_msg).
is_output_modelet_concept(order_dominating_engine, weak_ordering).
interface_of(order_dominating_engine, order_template_set).

engine(order_condorcet_engine).
output_modelet_formalism(order_lexicographical_engine, weak_ordering_msg).
is_output_modelet_concept(order_lexicographical_engine, weak_ordering).
interface_of(order_lexicographical_engine, order_template_set).

% Take
template_set(take_template_set).
is_in_template_set(weak_ordering_template, take_template_set).
% TODO: switch these for lists
% take_template_set = [weak_ordering_template]

engine(take_best_engine).
output_modelet_formalism(take_best_engine, alternative_array_msg).
is_output_modelet_concept(take_best_engine, alternative_array).
is_output_modelet_representation_class(take_best_engine, choice).
interface_of(take_best_engine, take_template_set).

engine(eliminate_worst_engine).
output_modelet_formalism(eliminate_worst_engine, alternative_array_msg).
is_output_modelet_concept(eliminate_worst_engine, alternative_array).
is_output_modelet_representation_class(eliminate_worst_engine, choice).
interface_of(eliminate_worst_engine, take_template_set).

% Accept
template_set(accept_template_set).
is_in_template_set(choice_template, accept_template_set).
is_in_template_set(evaluation_template, accept_template_set).
% TODO: switch these for lists
% accept_template_set = [choice_template, evaluation_template]

engine(accept_always_engine).
output_modelet_formalism(accept_always_engine, decision_msg).
is_output_modelet_concept(accept_always_engine, decision).
interface_of(accept_always_engine, accept_template_set).

engine(accept_dominating_engine).
output_modelet_formalism(accept_dominating_engine, decision_msg).
is_output_modelet_concept(accept_dominating_engine, decision).
interface_of(accept_dominating_engine, accept_template_set).

engine(accept_satisficing_engine).
output_modelet_formalism(accept_satisficing_engine, decision_msg).
is_output_modelet_concept(accept_satisficing_engine, decision).
interface_of(accept_satisficing_engine, accept_template_set).

engine(accept_size_engine).
output_modelet_formalism(accept_size_engine, decision_msg).
is_output_modelet_concept(accept_size_engine, decision).
interface_of(accept_size_engine, accept_template_set).
