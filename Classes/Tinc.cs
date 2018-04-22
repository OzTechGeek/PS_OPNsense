﻿using System;
using System.Management.Automation;

namespace OPNsense.Tinc {
	public class Host {
		#region Parameters
		public PSObject cipher { get; set; }
		public bool connectTo { get; set; }
		public bool enabled { get; set; }
		public string extaddress { get; set; }
		public int extport { get; set; }
		public string hostname { get; set; }
		public PSObject network { get; set; }
		public string pubkey { get; set; }
		public PSObject subnet { get; set; }
		#endregion Parameters

		public Host () {
			cipher = null;
			connectTo = false;
			enabled = false;
			extaddress = null;
			extport = 0;
			hostname = null;
			network = null;
			pubkey = null;
			subnet = null;
		}

		public Host (
			PSObject Cipher,
			bool ConnectTo,
			bool Enabled,
			string Extaddress,
			int Extport,
			string Hostname,
			PSObject Network,
			string Pubkey,
			PSObject Subnet
		) {
			cipher = Cipher;
			connectTo = ConnectTo;
			enabled = Enabled;
			extaddress = Extaddress;
			extport = Extport;
			hostname = Hostname;
			network = Network;
			pubkey = Pubkey;
			subnet = Subnet;
		}
	}
	public class Network {
		#region Parameters
		public PSObject cipher { get; set; }
		public PSObject debuglevel { get; set; }
		public bool enabled { get; set; }
		public string extaddress { get; set; }
		public int extport { get; set; }
		public string hostname { get; set; }
		public int id { get; set; }
		public PSObject intaddress { get; set; }
		public PSObject mode { get; set; }
		public string name { get; set; }
		public int pingtimeout { get; set; }
		public bool PMTUDiscovery { get; set; }
		public string privkey { get; set; }
		public string pubkey { get; set; }
		public PSObject subnet { get; set; }
		#endregion Parameters

		public Network () {
			cipher = null;
			debuglevel = null;
			enabled = false;
			extaddress = null;
			extport = 0;
			hostname = null;
			id = 0;
			intaddress = null;
			mode = null;
			name = null;
			pingtimeout = 0;
			PMTUDiscovery = false;
			privkey = null;
			pubkey = null;
			subnet = null;
		}

		public Network (
			PSObject Cipher,
			PSObject Debuglevel,
			bool Enabled,
			string Extaddress,
			int Extport,
			string Hostname,
			int Id,
			PSObject Intaddress,
			PSObject Mode,
			string Name,
			int Pingtimeout,
			bool pmtudiscovery,
			string Privkey,
			string Pubkey,
			PSObject Subnet
		) {
			cipher = Cipher;
			debuglevel = Debuglevel;
			enabled = Enabled;
			extaddress = Extaddress;
			extport = Extport;
			hostname = Hostname;
			id = Id;
			intaddress = Intaddress;
			mode = Mode;
			name = Name;
			pingtimeout = Pingtimeout;
			PMTUDiscovery = pmtudiscovery;
			privkey = Privkey;
			pubkey = Pubkey;
			subnet = Subnet;
		}
	}
}
