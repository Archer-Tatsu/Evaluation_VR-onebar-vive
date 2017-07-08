for i=1:size(peoplelist,1)
    for j=1:size(videolist,1)
        eval(['data=' peoplelist{i} '(j).Data;']);
        up=0;down=0;front=0;back=0;left=0;right=0;
        for k=1:size(data,1)
            phi=data(k,2);
            theta=data(k,1);
            if(abs(phi)>=45)&&(abs(phi)<135)
                if(abs(tan(theta*pi/180))>abs(sin(phi*pi/180)))
                    if theta>0
                        up=up+1;
                    else
                        down=down+1;
                    end
                else
                    if(phi>0)
                        left=left+1;
                    else
                        right=right+1;
                    end
                end
            else
                if(abs(tan(theta*pi/180))>cos(sin(phi*pi/180)))
                    if theta>0
                        up=up+1;
                    else
                        down=down+1;
                    end
                else
                    if(abs(phi)<45)
                        front=front+1;
                    else
                        back=back+1;
                    end
                end
            end
        end
        f_temp=[front left back right up down];
        f_temp=f_temp/sum(sum(f_temp));
        eval([peoplelist{i} '(j).Freq=f_temp;']);
    end
end