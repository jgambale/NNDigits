classdef RotationLayer < nnet.layer.Layer

    properties
     
    end

    properties (Learnable)

    end
    
    methods
        function layer = RotationLayer(name)
            layer.NumInputs = 2;
            layer.Name = name;
        end

        function XR = predict(layer, in1, in2)
            % Can technically make this setup better if height/width were
            % properties of the layer (using the inputparse, but this'll
            % do for now.
            MBS = numel(in2)/784;
            for i=1:MBS
                in2(:,:,:,i) = imrotate(extractdata(in2(:,:,:,i)),extractdata(in1(i)),'bicubic','crop');
            end
            XR = dlarray(in2);
        end
    end
end