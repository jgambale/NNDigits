function [W1, W2] = genrotnet
    [XTrain,~,~] = digitTrain4DArrayData;
    [XTest,~,~] = digitTest4DArrayData;
    AnglesTrain = zeros(length(XTrain(:,:,:)),1); AnglesTest = zeros(length(XTest(:,:,:)),1);
    for i=1:5000
        iiq = XTrain(:,:,:,i);iiq2 = XTest(:,:,:,i);
        bw=imbinarize(iiq,'adaptive','ForegroundPolarity','dark','sensitivity',0.3)';bw2 =imbinarize(iiq2,'adaptive','ForegroundPolarity','dark','sensitivity',0.3)';
        s = regionprops(bw,'Orientation','Area');s2 = regionprops(bw2,'Orientation','Area');
        [~,idx]=max([s.Area]);[~,idx2]=max([s2.Area]);
        AnglesTrain(i)=s(idx).Orientation;AnglesTest(i)=s2(idx2).Orientation;
    end
    
    img = XTrain(:,:,:,1);
    sz = size(img);
    numFeatures = 128;
    
    layers = [
        imageInputLayer([sz,1],"Name","imageinput")
        convolution2dLayer([2 2],8,"Padding","same")
        batchNormalizationLayer("Name","batch_1")
        reluLayer("Name",'relu_1')
        maxPooling2dLayer([2 2],"Padding","same","Name","pool_1")
        fullyConnectedLayer(numFeatures,"Name","feature")
        sigmoidLayer('Name','sigmoid')
        fullyConnectedLayer(1,"Name","angleoutput")
        regressionLayer("Name","regutput")];

    lg = layerGraph(layers);

    [train_idx, val_idx] = dividerand(size(XTrain,4), 0.7, 0.3);
    XTrain1 = XTrain(:,:,:,train_idx);
    XVal1 = XTrain(:,:,:,val_idx);
    AnglesTrain1 = AnglesTrain(train_idx);
    AnglesVal1 = AnglesTrain(val_idx);
    
    options = trainingOptions('adam', ...
                              'MaxEpochs', 1024,...
                              'MiniBatchSize', 512,...
                              'ValidationData',{XVal1,AnglesVal1},...
                              'ValidationPatience',4,...
                              'Plots','training-progress');
       
    net = trainNetwork(XTrain1,AnglesTrain1,lg,options);
    save('TestNet','net');
end