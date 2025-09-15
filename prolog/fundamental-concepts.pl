%%% Fundamental Concepts


%% Types

% The class of phenomenon in the world model that the system represents using
% modelets.
%
% concept(?Concept)

:- dynamic concept/1.
:- multifile concept/1.

% Methods used to express modelets (class in the data model).
% e.g. ROS Message types
%
% formalism(?Formalism)
:- dynamic formalism/1.
:- multifile formalism/1.

% The fundamental types of data considered.
%
% datatype(?Datatype)
:- dynamic datatype/1.
:- multifile datatype/1.

% How a modelet is used by engines (class in the processing model).
%
% representation_class(?Representation_class)
:- dynamic representation_class/1.
:- multifile representation_class/1.
