classdef tempclass < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        u
        v
        w
        p
        q
        r
    end
    
    methods
        function obj = tempclass()
            obj.u = 1;
            obj.v = 2;
            obj.w = 3;
            obj.p = 4;
            obj.q = 5;
            obj.r = 6;
        end
        
        function varargout = getState(obj,res)
            switch res
                case 1
                    varargout{1} = obj.u;
                    varargout{2} = obj.v;
                    varargout{3} = obj.w;
                case 2
                    varargout{1} = obj.u;
                    varargout{2} = obj.v;
                    varargout{3} = obj.w;
                    varargout{4} = obj.p;
                    varargout{5} = obj.q;
                    varargout{6} = obj.r;
            end
        end
    end
    
end

