f_threshold=1/6;
for i_video=1:size(videolist,1)
    DMOS=[];up=[];down=[];left=[];right=[];front=[];back=[];
    n=size(peoplelist,1);
    for i_subject=1:n
        eval(['temp=' videolist{i_video} ';']);
        DMOS=[DMOS;temp(i_subject).DMOS];
        f=temp(i_subject).Freq;
        if f(1)>f_threshold
            front=[front;temp(i_subject).DMOS];
        end
        if f(2)>f_threshold
            left=[left;temp(i_subject).DMOS];
        end
        if f(3)>f_threshold
            back=[back;temp(i_subject).DMOS];
        end
        if f(4)>f_threshold
            right=[right;temp(i_subject).DMOS];
        end
        if f(5)>f_threshold
            up=[up;temp(i_subject).DMOS];
        end
        if f(6)>f_threshold
            down=[down;temp(i_subject).DMOS];
        end
    end
    VDMOS(i_video)=struct('Name',videolist{i_video},'DMOS',mean(DMOS),'DMOSfront',mean(front),'DMOSleft',mean(left),'DMOSback',mean(back),'DMOSright',mean(right),'DMOSup',mean(up),'DMOSdown',mean(down));
end