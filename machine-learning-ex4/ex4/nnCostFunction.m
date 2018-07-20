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
% cd '/Users/omri/Downloads/machine-learning/machine-learning-ex4/ex4/'

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));
% 25 * 401



Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));
%10 * 26


Layers=3;
% Setup some useful variables
m = size(X, 1);

% Add ones
for i=1:m,
  y_matrix(i,:)=(eye(num_labels)(:,y(i)))'; % 5000 * 10
end

%a1=ones(1,401);
a1 = [ones(m, 1) X]; % 5000 * 401
z2=a1*Theta1'; % 5000 * 25
a2=sigmoid(z2); % 5000 * 25
a2 = [ones(m,1), a2];% 5000 * 26
z3=Theta2*a2';% 5000 * 10
a3=sigmoid(z3);% 5000 * 10
h=a3;

%h=sigmoid(Theta2*[ones(1,size(sigmoid(Theta1*a1'))(2));sigmoid(Theta1*a1')]);

J=sum(sum((-y_matrix.*log(h') - ((1-y_matrix).*log(1- (h'))))))/m;

reg=(lambda/(2*m))*(sum(sum(Theta1(:,2:size(Theta1)(2)).^2))+sum(sum(Theta2(:,2:size(Theta2)(2)).^2)));

J=J+reg;

delta3=h-y_matrix'; % 5000 * 10
delta2=delta3'*Theta2(:,2:end);  % 5000 * 25
delta2=delta2.*sigmoidGradient(z2);
DELTA2=delta3*a2(:,1:end);
DELTA1=delta2'*a1(:,1:end);





% You need to return the following variables correctly 
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));


Theta1_grad = DELTA1/m;
Theta2_grad = DELTA2/m;


Theta1_grad (:,2:end)+= (lambda/m)*Theta1(:,2:end);
Theta2_grad (:,2:end)+=(lambda/m)*Theta2(:,2:end);

%I should add theta to DELTA where j!=0



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
% -------------------------------------------------------------
% =========================================================================
% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];
end