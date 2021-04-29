function action = choose_action(obs)
	load('params.mat');
    action_list = [0.44 : 0.01 : 0.55];
    x1 = relu(W1 * obs + b1);
    x2 = relu(W2 * x1 + b2);
    Q = W3 * x2 + b3;
    disp(Q);
    [val, idx] = max(Q);
    action = action_list(idx);
end