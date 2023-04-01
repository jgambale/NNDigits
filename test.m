%% MNIST Dataset
% Gather data from MNIST dataset
filenameImagesTrain = 'train-images-idx3-ubyte.gz';
filenameLabelsTrain = 'train-labels-idx1-ubyte.gz';
filenameImagesTest = 't10k-images-idx3-ubyte.gz';
filenameLabelsTest = 't10k-labels-idx1-ubyte.gz';

XTrain = processImagesMNIST(filenameImagesTrain);
YTrain = processLabelsMNIST(filenameLabelsTrain);
XTest = processImagesMNIST(filenameImagesTest);
YTest = processLabelsMNIST(filenameLabelsTest);

% Generate the Rotation Net and load it.
% genrotnet;

load TestNet.mat;
rotlayers = net.Layers(1:8);

XComb = cat(4,XTrain,XTest);
YComb = cat(1,YTrain,YTest);

A = categories(YComb);
sz = size(XComb(:,:,:,1));

[train_idx, val_idx] = dividerand(size(XComb,4), 0.7, 0.3);
XTrain1 = XComb(:,:,:,train_idx);
XVal1 = XComb(:,:,:,val_idx);
YTrain1 = YComb(train_idx);
YVal1 = YComb(val_idx);

layers = [
    rotlayers
    RotationLayer("RotatoPotato")
    convolution2dLayer([2 2],8,"Padding","same")
    batchNormalizationLayer("Name","batch_2")
    reluLayer("Name",'relu_2')
    maxPooling2dLayer([2 2],"Padding","same","Name","pool_2")
    fullyConnectedLayer(numel(A),"Name","fcclass")
    softmaxLayer("Name","softmaxclass")
    classificationLayer("Name","classoutput")];

layers(1:8) = freezeWeights(layers(1:8));

lg = layerGraph(layers);
lg = connectLayers(lg,"imageinput","RotatoPotato/in2");

options = trainingOptions('adam',...
                        'MaxEpochs',32,...
                        'MiniBatchSize',128, ...
                        'ValidationData',{XVal1,YVal1},...
                        'ValidationPatience',10,...
                        'Plots','training-progress');

net2 = trainNetwork(XTrain1,YTrain1,lg,options);

[Predicted,p] = classify(net2,XComb);

nErrors = numel(find(Predicted ~= YComb));
disp("Accuracy of Model: " + (1-nErrors/70000));