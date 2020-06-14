function varargout = Filelistbox(varargin)
% WORLDVIS Application M-file for Filelistbox.fig
%    FIG = WORLDVIS launch Filelistbox GUI.
%    WORLDVIS('callback_name', ...) invoke the named callback.

if nargin <= 1   % LAUNCH GUI
    if nargin == 0
        initial_dir = pwd;
    elseif nargin == 1 & exist(varargin{1},'dir')
        initial_dir = varargin{1};
    else
        errordlg('Input argument must be a valid directory',...
            'Input Argument Error!')
        return
    end

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

    % Call the popup menu callback to initialize the handles.data 
    % field with the current value of the popup
    % Month_popup_Callback(handles.Month_popup,[],handles)
    handles.data=1; % Display current directory
    handles.Smoothing='nosmooth';
    handles.Europe='';
    handles.Title='';
    handles.Units='';
    handles.Min='';
    handles.Max='';
    handles.Discreet='cont';
    handles.Figure=1;
    
    load_listbox(initial_dir,handles)
    
	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	catch
		disp(lasterr);
	end

end


% --------------------------------------------------------------------
function varargout = listbox1_Callback(h, eventdata, handles, varargin)
% Stub for Callback of the uicontrol handles.listbox1.
if strcmp(get(handles.figure1,'SelectionType'),'open') % If double click
    index_selected = get(handles.listbox1,'Value');
    file_list = get(handles.listbox1,'String');
    filename = file_list{index_selected}; % Item selected in list box
    if  handles.is_dir(handles.sorted_index(index_selected)) % If directory
        cd (filename)
        load_listbox(pwd,handles) % Load list box with new directory
    else
        month=handles.data;
        Smoothing=handles.Smoothing;
        Title=handles.Title;
        Units=handles.Units;
        Europe=handles.Europe;
        if ~isequal(handles.Min,'')
            Min=eval([handles.Min]);
        else
            Min=handles.Min;
        end
        if ~isequal(handles.Max,'')
            Max=eval([handles.Max]);
        else
            Max=handles.Max;
        end
        Discreet=handles.Discreet;
        Figure=handles.Figure;
        worldformat(filename,month,Smoothing,Title,...
            Units,Min,Max,Europe,Discreet,Figure)        
    end
end

% --------------------------------------------------------------------
function varargout = Month_popup_Callback(h, eventdata, handles, varargin)
handles.data = get(h,'Value');
guidata(h,handles) % Save the handles structure after adding data

% --------------------------------------------------------------------
function varargout = Discreet_Callback(h, eventdata, handles, varargin)
if (get(h,'Value') == get(h,'Max'))
    handles.Discreet='disc';
else
    handles.Discreet='cont';
end
guidata(h,handles)

% --------------------------------------------------------------------
function varargout = Smoothing_Callback(h, eventdata, handles, varargin)
if (get(h,'Value') == get(h,'Max'))
    handles.Smoothing='smooth';
else
    handles.Smoothing='nosmooth';
end
guidata(h,handles)

% --------------------------------------------------------------------
function varargout = Europe_Callback(h, eventdata, handles, varargin)
if (get(h,'Value') == get(h,'Max'))
    handles.Europe='europe';
else
    handles.Europe='';
end
guidata(h,handles)

% --------------------------------------------------------------------
function varargout = UnitsText_Callback(h, eventdata, handles, varargin)
handles.Units = get(h,'string');
guidata(h,handles)

% --------------------------------------------------------------------
function varargout = TitleText_Callback(h, eventdata, handles, varargin)
handles.Title = get(h,'string');
guidata(h,handles)

% --------------------------------------------------------------------
function varargout = MinText_Callback(h, eventdata, handles, varargin)
handles.Min = get(h,'string');
guidata(h,handles)

% --------------------------------------------------------------------
function varargout = MaxText_Callback(h, eventdata, handles, varargin)
handles.Max = get(h,'string');
guidata(h,handles)

% --------------------------------------------------------------------
function varargout = FigureText_Callback(h, eventdata, handles, varargin)
handles.Figure=get(h,'string');
handles.Figure=eval([handles.Figure]);
guidata(h,handles)

% --------------------------------------------------------------------
function varargout = Visualize_Callback(h, eventdata, handles, varargin)
index_selected = get(handles.listbox1,'Value');
file_list = get(handles.listbox1,'String');
filename = file_list{index_selected}; % Item selected in list box
if  handles.is_dir(handles.sorted_index(index_selected)) % If directory
    cd (filename)
    load_listbox(pwd,handles) % Load list box with new directory
else
    month=handles.data;
    Smoothing=handles.Smoothing;
    Europe=handles.Europe;
    Title=handles.Title;
    Units=handles.Units;
    if ~isequal(handles.Min,'')
        Min=eval([handles.Min]);
    else
        Min=handles.Min;
    end
    if ~isequal(handles.Max,'')
        Max=eval([handles.Max]);
    else
        Max=handles.Max;
    end
    Discreet=handles.Discreet;
    Figure=handles.Figure;
    worldformat(filename,month,Smoothing,Title,...
        Units,Min,Max,Europe,Discreet,Figure)        
end

