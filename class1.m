classdef class1 < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data1
        data2
    end
    
    methods
        function obj = class1(dataobj)
            %
            obj.data1 = 10;
            obj.data2 = dataobj;
        end
        
        function getProperty(obj)
            tmp = obj.data1;
        end
        
        function getData(obj)
            tmp = obj.data2.data;
        end
    end
    
end

