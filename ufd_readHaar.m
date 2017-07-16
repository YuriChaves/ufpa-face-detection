function cascade=ufd_readHaar(haarFilename)
% This function reads a MAT file with a MATLAB structure 
% containing a Haar cascade classifier data.
% This code assumes the "old" XML format. OpenCV has now a newer
% format. See youtube videolecture about it.
% Input: MATLAB filename
% Output: Structure containing the classifier
% (Based on code by D. Kroon)
load(haarFilename); %haarFilename is a MAT file
f=fieldnames(opencv_storage);
cascade=opencv_storage.(f{1});

% Add all missing data-fields
stages=cascade.stages;
for i=1:length(stages)
   stages2(i).stage_threshold=stages(i).stage_threshold;
   stages2(i).parent=stages(i).parent;
   stages2(i).next=stages(i).next;
	for j=1:length(stages(i).trees);
		for k=1:length(stages(i).trees(j).value)
			a=stages(i).trees(j).value(k);
			if(~isfield(a,'left_node')) , a.left_node=[]; end
			if(~isfield(a,'right_node')), a.right_node=[];end
			if(~isfield(a,'left_val'))  , a.left_val=[];  end
			if(~isfield(a,'right_val')) , a.right_val=[]; end
			if(isempty(a.left_val)),  a.left_val=-1;  end
			if(isempty(a.right_val)), a.right_val=-1; end
			if(isempty(a.left_node)), a.left_node =-1; end
			if(isempty(a.right_node)),a.right_node=-1; end
            a.rects1=a.feature.rects(1).value;
            a.rects2=a.feature.rects(2).value;
            if(length(a.feature.rects)>2), 
                a.rects3=a.feature.rects(3).value; 
            else
                a.rects3=[0 0 0 0 0];
            end
            a.tilted=a.feature.tilted;
			if(any(a.tilted))
				warning('cascade:file','Tilted features are not supported');
			end
			
            a=rmfield(a,'feature');
            % Stage values and features to one big array
			stages2(i).trees(j).value(k,:)=[a.threshold a.left_val a.right_val a.left_node a.right_node a.rects1 a.rects2 a.rects3 a.tilted];
		end
	end
end
cascade.stages=stages2;