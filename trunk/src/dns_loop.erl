%%%---------------------------------------------------------------------------------------
%%% @author     Stuart Jackson <simpleenigma@gmail.com> [http://erlsoft.org]
%%% @copyright  2006 - 2007 Simple Enigma, Inc. All Rights Reserved.
%%% @doc        DNS server loop
%%% @reference  See <a href="http://erlsoft.org/modules/erldir" target="_top">Erlang Software Framework</a> for more information
%%% @reference See <a href="http://erldir.googlecode.com" target="_top">ErlDir Google Code Repository</a> for more information
%%% @version    0.0.2
%%% @since      0.0.1
%%% @end
%%%
%%%
%%% The MIT License
%%%
%%% Copyright (c) 2007 Stuart Jackson, Simple Enigma, Inc. All Righs Reserved
%%%
%%% Permission is hereby granted, free of charge, to any person obtaining a copy
%%% of this software and associated documentation files (the "Software"), to deal
%%% in the Software without restriction, including without limitation the rights
%%% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%%% copies of the Software, and to permit persons to whom the Software is
%%% furnished to do so, subject to the following conditions:
%%%
%%% The above copyright notice and this permission notice shall be included in
%%% all copies or substantial portions of the Software.
%%%
%%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%%% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%%% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%%% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%%% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%%% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
%%% THE SOFTWARE.
%%%
%%%
%%%---------------------------------------------------------------------------------------
-module(dns_loop).
-author('sjackson@simpleenigma.com').
-include("../include/dns.hrl").

-compile(export_all).

start_link(From, Socket, Port, Type) ->proc_lib:spawn_link(?MODULE, init, [{From, Socket, Port, Type}]).

init({_From, Socket, _Port, _Type}) -> % Listen_Pid, Listen_Socket, Listen_Port, Type [tcp|udp]
%	dns_server:create(From, self(), Type),
	receive
		{udp,Socket,_IP,_InPortNo,Packet} -> 
			io:format("~p~n",[Packet]),
			Message = dns_enc:decode(Packet),
			io:format("~p~n",[Message]),
			gen_udp:close(Socket);
		{tcp,Socket,Packet} -> 
			io:format("~p~n",[Packet]),
			Message = dns_enc:decode(Packet),
			io:format("~p~n",[Message]),
			gen_tcp:close(Socket);
		{error,Reason} ->
			io:format("UDP Error: ~p~n",[Reason]),
			{error,Reason}
	end.	