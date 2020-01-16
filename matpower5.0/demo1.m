function varargout = demo1(varargin)
% DEMO1 MATLAB code for demo1.fig
%      DEMO1, by itself, creates a new DEMO1 or raises the existing
%      singleton*.
%
%      H = DEMO1 returns the handle to a new DEMO1 or the handle to
%      the existing singleton*.
%
%      DEMO1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEMO1.M with the given input arguments.
%
%      DEMO1('Property','Value',...) creates a new DEMO1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before demo1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to demo1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help demo1

% Last Modified by GUIDE v2.5 18-Jan-2017 07:00:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @demo1_OpeningFcn, ...
                   'gui_OutputFcn',  @demo1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before demo1 is made visible.
function demo1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to demo1 (see VARARGIN)

% Choose default command line output for demo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes demo wait for user response (see UIRESUME)
% uiwait(handles.figure1);
img = imread('Banshee.jpg'); 
image(img, 'Parent', handles.axes1);
set(handles.axes1,'xtick',[],'ytick',[])


% UIWAIT makes demo1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = demo1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Utility.
function Utility_Callback(hObject, eventdata, handles)
% hObject    handle to Utility (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Utility
if handles.Utility.Value && handles.Inter.Value
        img = imread('BansheeCase1.jpg'); 
elseif handles.Utility.Value && ~handles.Inter.Value
        img = imread('BansheeCase2.jpg'); 
elseif ~handles.Utility.Value && handles.Inter.Value
        img = imread('BansheeCase3.jpg'); 
elseif ~handles.Utility.Value && ~handles.Inter.Value
        img = imread('BansheeCase4.jpg'); 
end
image(img, 'Parent', handles.axes1);
set(handles.axes1,'xtick',[],'ytick',[])
 



% --- Executes on button press in Inter.
function Inter_Callback(hObject, eventdata, handles)
% hObject    handle to Inter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.Utility.Value && handles.Inter.Value
        img = imread('BansheeCase1.jpg'); 
elseif handles.Utility.Value && ~handles.Inter.Value
        img = imread('BansheeCase2.jpg'); 
elseif ~handles.Utility.Value && handles.Inter.Value
        img = imread('BansheeCase3.jpg'); 
elseif ~handles.Utility.Value && ~handles.Inter.Value
        img = imread('BansheeCase4.jpg'); 
end
image(img, 'Parent', handles.axes1);
set(handles.axes1,'xtick',[],'ytick',[])


% Hint: get(hObject,'Value') returns toggle state of Inter
