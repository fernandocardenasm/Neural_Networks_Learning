function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

%Basic Structure
%a1 = X
%z2 = a1 * Theta1'
%a2 = sigmoid(z2)
%z3 = a2 * Theta'
%a3 = sigmoid(z3) = hx

X = [ones(m, 1) X];
%%Y Will have the same of number of labels as rows
y = eye(num_labels)(y,:);

z2 = X * Theta1';

a2 = sigmoid(z2);

a2 = [ones(m, 1) a2];

z3 = a2 * Theta2';

hx = sigmoid(z3);

%J Cost without Regularization

J_partial = 0;

%Version with loop

for k=1:num_labels

 J_partial = J_partial + (-y(:,k)' * log(hx(:,k)) - (1 - y(:,k))' * log(1 - hx(:,k)));

endfor

J_partial = J_partial ./ m;

%%Regularization Cost Added
%%In this case we ignore the first column of each Theta
J_regularization = (lambda/(2*m)) * (sum(sum(Theta1(:,2:end).^2)) + sum(sum(Theta2(:,2:end).^2)));

J = J_partial + J_regularization;

%Version without loop for cost without regularization cost
%J = ((1/m) * sum(sum((-y .* log(hx))-((1-y) .* log(1-hx)))))


error3 = hx - y;

%We delete from error2, the column  sub 0, which in Octave is the first one. 

error2 = (error3 * Theta2(:, 2:end)) .* sigmoidGradient(z2);

%Delta2 has as output 10 x 26. The layer 3, has 10 outputs and 26 inputs. Bias added
delta2 = error3' * a2;
%Delta1 has as output 25 x 401. The layer 2, has 25 outputs and 401 inputs
delta1 = error2' * X;

%At the end this delta2 and delta3 will become our new theta. That´s why size(delta1)==size(Theta1)
%size(delta2)==size(Theta2)

%We dont consider the first column of Theta for the regularization

Theta1(:,1) = zeros(size(Theta1,1),1);
Theta2(:,1) = zeros(size(Theta2,1),1);

Theta1_grad = ((1/m) * delta1) + ((lambda/m) * Theta1);
Theta2_grad = ((1/m) * delta2) + ((lambda/m) * Theta2);










% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
