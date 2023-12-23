function CM = simConn_L4toL4_SStetoAll(ADO_Mat, postIND, postType, AxonRatio, DendRatio, DMs)
% ADO_Mat: axon-dendritic overlap matrix
% postIND: indexing to seperate different type of post synaptic cells
% postType: numbers specify the type of post-synaptic cell
% keyboard
% connectivity matrix need to be calculated for each type of post synaptic
% cell
for i = 1:length(postIND) - 1
    temp = ADO_Mat(postIND(i)+1:postIND(i+1), :);

%     ADO_temp = temp;
%     DM = DMs(postIND(i)+1:postIND(i+1), :);
%     DR = DendRatio(postIND(i)+1:postIND(i+1));

    switch postType(i)
        case(1) % post-synaptic cell is star pyramidal
            CM(postIND(i)+1:postIND(i+1), :) = simConn_L4toL4_SStetoSPyr(temp, AxonRatio, DendRatio(postIND(i)+1:postIND(i+1)));
        case(2) % post-synaptic cell is spiny stallete
            CM(postIND(i)+1:postIND(i+1), :) = simConn_L4toL4_SStetoSSte(temp, AxonRatio, DendRatio(postIND(i)+1:postIND(i+1)));
        case(3) % post-synaptic cell is RsPV
            CM(postIND(i)+1:postIND(i+1), :) = simConn_L4toL4_SStetoFsPV(temp, AxonRatio, DendRatio(postIND(i)+1:postIND(i+1)));
        case(4) % post-synaptic cell is MarSOM
            CM(postIND(i)+1:postIND(i+1), :) = simConn_L4toL4_SStetoRSNP(temp, AxonRatio, DendRatio(postIND(i)+1:postIND(i+1)));
    end
end

%% nested function
    function CMs = simConn_L4toL4_SStetoSPyr(ADO_temp, AR, DR)
        % map axon-dendrite overlapping index into connectivity matrix
        % the value is normalized to meausre average connection probability
        % from experiment; for Pyr-Pyr connection, within 100 micron p =
        % 0.21
        % also total number of connection is controlled by the axon and
        % dendrite ratio in the model region
        % assuming a total convengenc/divergence rate of 140 for total
        % connection
        
        pConn = ADO_temp/3.6454e-12*0.27;
        % convert pConn into binary connectivity matrix
        pConn(pConn > 0.25) = 0.25;
        RI = rand(size(pConn));
        CMs = zeros(size(pConn));
        CMs(RI < pConn) = 1;
        
        CMs = conn_reduction(CMs, 100*AR', 130*DR');
    end


    function CMs = simConn_L4toL4_SStetoSSte(ADO_temp, AR, DR)
        % for Pyr-FsPV connection, within 50 micron p =
        % 0.18
        % assuming a total convengenc rate of 700 and divergence rate of 90
        
        pConn = ADO_temp/3.7471e-12*0.28;
        % convert pConn into binary connectivity matrix
        pConn(pConn > 0.25) = 0.25;
        RI = rand(size(pConn));
        CMs = zeros(size(pConn));
        CMs(RI < pConn) = 1;
        
        CMs = conn_reduction(CMs, 130*AR', 130*DR');
    end


    function CMs = simConn_L4toL4_SStetoFsPV(ADO_temp, AR, DR)
        % for Pyr-FsPV connection, within 100 micron p =
        % 0.5
        % assuming a total convengenc rate of 240 and divergence rate of 40
        
        pConn = ADO_temp/6.1930e-12*0.61;
        % convert pConn into binary connectivity matrix
        RI = rand(size(pConn));
        CMs = zeros(size(pConn));
        CMs(RI < pConn) = 1;
        
        CMs = conn_reduction(CMs, 72*AR', 320*DR');
    end


    function CMs = simConn_L4toL4_SStetoRSNP(ADO_temp, AR, DR)
        % for Pyr-MarSOM connection, no connection
        % assuming a total convengenc rate of 700 and divergence rate of 90
%         
        pConn = ADO_temp/6.1268e-12*0655;
        % convert pConn into binary connectivity matrix
        RI = rand(size(pConn));
        CMs = zeros(size(ADO_temp));
        CMs(RI < pConn) = 1;
        
        CMs = conn_reduction(CMs, 72*AR', 320*DR');
    end


end

% %%
% %check connection probability as a function of distance
% bin = 0:25:500;
% N_all = [0, cumsum(NiN2)];
% Pconn = {};
% for post = 1:length(N_all) - 1
%     Pconn{post,1} = PConn_pairs(CM_modified(N_all(post)+1:N_all(post+1),:), ...
%         bin, DM(N_all(post)+1:N_all(post+1), :));
% end