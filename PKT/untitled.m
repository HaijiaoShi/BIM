function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 24-Nov-2022 00:06:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @untitled_OpeningFcn, ...
    'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% path=uigetfile;
% files=dir(fullfile(path,'*.xml'));
% files={files.name}';
%
% %set(handles.listbox1,'string',files);
% handles.path=path;
% handles.output = hObject;


[b,a]=uigetfile({'*.xml';'*.mat';'*.xlsx';'*.xls'},'Please select the model file');
model_path=fullfile(a,b);
u=waitbar(0,'Loading model...');
pause(.5)
modelori=readCbModel(model_path);
% handles.modelori=modelori;
% guidata(hObject, handles);
model1=modelori;
model=modelori;
waitbar(0.5,u,'Loading model...');
pause(.5)
model = changeRxnBounds(model,'EX_etoh_e',8,'l');
model = changeRxnBounds(model,'EX_lac__L_e',0.667,'l');
model = changeRxnBounds(model,'EX_ac_e',4,'l');
model = changeRxnBounds(model,'EX_glc__D_e',-3.33,'u');
model = changeRxnBounds(model,'EX_glc__D_e',-10,'l');
handles.model=model;
waitbar(1,u,'Model loaded!');
pause(.5)
msgbox("Please export as.xls file!");
pause(5)
writeCbModel(model)
close(u)
guidata(hObject, handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msgbox("Please enter the model's Excel file!");
pause(5)
[C,D]=uigetfile({'*.xls'},'Please select the reaction file');
reaction_path=fullfile(D,C);
y=waitbar(0,'Please wait...');
pause(.5)
guidata(hObject, handles);
title={"number","Abbreviation","Description","Reaction","EC Number","KEGG ID","biomass-max","carbon content","carbon loading","bio.f.w","bio_Minimum Flux","bio_Maximum Flux","bio.d.f","Can bio be tapped","product.f.w","product_Minimum Flux","product_Maximum Flux","product.d.f","Can the product be tapped","suggest knocking out"};
xlswrite('result.xlsx',title,'Sheet1','A1');
res1={}
for i=1:1175
    po=i;
    res1=[res1,po];
end
res1=res1';
xlswrite('result.xlsx',res1,'Sheet1','A2');
[~,~,data1]=xlsread(reaction_path,'Reaction List','A1:C1176');
[~,~,data2]=xlsread(reaction_path,'Reaction List','J1:K1176');
xlswrite('result.xlsx',data1,'Sheet1','B1');
xlswrite('result.xlsx',data2,'Sheet1','E1');



waitbar(0.2,y,'Loading your data...');
pause(.5)
model=handles.model
model_1=changeObjective(model,'biomass');
FBAsolution = optimizeCbModel(model_1,'max','one');
xlswrite('result.xlsx',FBAsolution.v,'Sheet1','G2');



f=optimizeCbModel(model_1);
xlswrite('result.xlsx',f.w,'Sheet1','J2');

[minFlux1, maxFlux1, ~, ~] = fluxVariability(model_1, 100, 'max', [], 0, 1, 'FBA');
xlswrite('result.xlsx',minFlux1,'Sheet1','K2');
xlswrite('result.xlsx',maxFlux1,'Sheet1','L2');

[~,~,energySources]=xlsread(reaction_path,'Reaction List',"A2:A1176");
Res1={};
for i=1:length(energySources)
    res2={};
    model21=changeRxnBounds(model_1,energySources{i},0,'b');
    f2=optimizeCbModel(model21);
    res2=f2.f;
    Res1=[Res1;res2];
    %Res1=Res1';
end
xlswrite('result.xlsx',Res1,'Sheet1','M2');

waitbar(0.4,y,'Processing your data...');
pause(.5)
Res={};
for ii=1:length(Res1)
    if Res1{ii}>=0.31;
        res="√";
        Res=[Res,res];
    else
        res="×";
        Res=[Res,res];
    end
end
Res=Res';
xlswrite('result.xlsx',Res,'Sheet1','N2');


waitbar(0.55,y,'Please wait a moment ...');
pause(.5)
model_new=handles.model_new;
f=optimizeCbModel(model_new);
xlswrite('result.xlsx',f.w,'Sheet1','O2');

[minFlux2, maxFlux2, ~, ~] = fluxVariability(model_new, 100, 'max', [], 0, 1, 'FBA');
xlswrite('result.xlsx',minFlux2,'Sheet1','P2');
xlswrite('result.xlsx',maxFlux2,'Sheet1','Q2');

[~,~,energySources]=xlsread(reaction_path,'Reaction List',"A2:A1176");
Res1={};
for i=1:length(energySources)
    res2={};
    model31=changeRxnBounds(model_new,energySources{i},0,'b');
    f2=optimizeCbModel(model31);
    res2=f2.f;
    Res1=[Res1;res2];
    %Res1=Res1';
end
xlswrite('result.xlsx',Res1,'Sheet1','R2');

waitbar(0.7,y,'Please wait...');
pause(.5)
Res={};
for ii=1:length(Res1)
    if Res1{ii}>=4.2;
        res="√";
        Res=[Res,res];
    else
        res="×";
        Res=[Res,res];
    end
end
waitbar(0.9,y,'Waiting....');
pause(.5)
Res=Res';
xlswrite('result.xlsx',Res,'Sheet1','S2');
waitbar(1,y,'Finishing!');
pause(2)
close(y)
delete(y)
guidata(hObject, handles);
handles.reaction_path=reaction_path
guidata(hObject, handles);

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, ~, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[~,~,data]=xlsread('result.xlsx');
data2=data(2:end,:);
[B,index]=sortrows(data2(:,9),-1);
data2=data2(index,:);
xlswrite('result.xlsx',data2,'Sheet2','A1');
[~,~,result]=xlsread("result.xlsx",'Sheet2');
Res1={};
Res2={};
Res3={};
Res4={};
for ii=2:length(result)
    if result{ii,14}=="√" & result{ii,19}=="√" ;
        name=result{ii,2};
        rea=result{ii,4};
        keggid=result{ii,6};
        ec=result{ii,5};
        Res1=[Res1,name];
        Res2=[Res2,rea];
        Res3=[Res3,keggid];
        Res4=[Res4,ec];
    else
        res="";
    end
end
Res1=Res1';
Res2=Res2';
Res3=Res3';
Res4=Res4';
Res1=cellstr(Res1(1:7,1))
Res2=cellstr(Res2(1:7,1))
Res3=cellstr(Res3(1:7,1))
Res4=cellstr(Res4(1:7,1))

% xuhao={1,2,3,4}';
% name={'A';'B';'C';'D'};
% reaction={'A';'B';'C';'D'};
% ec={'A';'B';'C';'D'};
% tab_data=table(xuhao,name,reaction,ec,'VariableNames',{'Serial Number','Name','Reaction','Enzyme Number'})

set(handles.uitable2,'data',[Res1,Res2,Res3,Res4]);
%set(handles.uitable2,'data',data2)

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if length(handles.edit1.String)<1
    msgbox("Please enter the reaction!");
    return
end
model=handles.model;
model_new=changeObjective(model,handles.edit1.String)
handles.model_new=model_new;
guidata(hObject, handles); 

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

reaction_path=handles.reaction_path
[~,~,chemdata]=xlsread(reaction_path,'Metabolite List');
chemdata(1,:)=[];
chemdata(:,[2,4:8])=[];
[~,~,fanying]=xlsread(reaction_path,'Reaction List');
fanying(:,[2,4:10])=[];
fanying(1,:)=[];

for i=1:length(chemdata)
    temdata=chemdata{i,2};
    C_shu=findC_shumu(temdata);
    chemdata{i,3}=C_shu;
end

Res=cell(length(fanying),10);
for i=1:length(fanying)
    temdata=fanying{i,2};
    res=find_fanying(temdata);
    for j=1:length(res)
        Res(i,j)=res(j);
    end
end

h=waitbar(0,'Please wait... calculating');
for i=1:length(Res)
    for j=1:70
        temdata=Res{i,j};
        flag=strfind(temdata,' ');
        if isempty(flag)
            flag=0;
        end
        temdata2=temdata(flag+1:end);
        for k=1:length(chemdata)
            temdata3=chemdata{k,1};
            if strcmp(temdata2,temdata3)
                temdata2=chemdata{k,3};
            end
        end
        if isempty(temdata2)
            temdata2=0;
        end
        xishu=temdata(1:flag-1);
        if isempty(xishu)
            xishu=1;
        else
            xishu=str2num(xishu);
        end
        C_shuliang=xishu*temdata2;
        C_yuanzi(i,j)=C_shuliang;
    end
    waitbar(i/length(Res),h,'Please wait... calculating')
end
close(h);
clear C_shu C_shuliang flag h i j k temdata...
    temdata2 temdata3 xishu

title={'Cnumber'};
res=num2cell(sum(C_yuanzi,2));
res=[title;res];
title2={'Cnumber'};
res2=chemdata(:,3);
res2=[title;res2];
[~,~,fanying]=xlsread(reaction_path,'Reaction List');
[~,~,chemdata]=xlsread(reaction_path,'Metabolite List');
fanying=[fanying,res];
chemdata=[chemdata,res2];
xlswrite('result.xlsx',res,'Sheet1','H1');

[~,~,G]=xlsread('result.xlsx','Sheet1','G2:G1176');
[~,~,H]=xlsread('result.xlsx','Sheet1','H2:H1176');
I={}
for i=1:1175
    chengji=G{i}*H{i};
    I=[I,chengji];
end
I=I';
xlswrite('result.xlsx',I,'Sheet1','I2');
guidata(hObject, handles);

% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject, handles);










% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
m= waitbar(0,'Initializing, please wait...');
pause(.2)
initCobraToolbox(false);
waitbar(0.5,m,'Almost done...');
pause(.5)
changeCobraSolver('gurobi','all');
waitbar(1,m,'Initialization successful!');
pause(1.5)
close(m)
disp('hello')

function Untitled_1_Callback(hObject,eventdata,handles)

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function pushbutton11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
