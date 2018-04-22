﻿using System;
using System.Management.Automation;

namespace OPNsense.Quagga {
	public class BGPAspath {
		#region Parameters
		public PSObject action { get; set; }
		public string AS { get; set; }
		public bool enabled { get; set; }
		public int number { get; set; }
		#endregion Parameters

		public BGPAspath () {
			action = null;
			AS = null;
			enabled = false;
			number = 0;
		}

		public BGPAspath (
			PSObject Action,
			string AS_,
			bool Enabled,
			int Number
		) {
			action = Action;
			AS = AS_;
			enabled = Enabled;
			number = Number;
		}
	}
	public class BGPNeighbor {
		#region Parameters
		public string address { get; set; }
		public bool defaultoriginate { get; set; }
		public bool enabled { get; set; }
		public PSObject linkedPrefixlistIn { get; set; }
		public PSObject linkedPrefixlistOut { get; set; }
		public PSObject linkedRoutemapIn { get; set; }
		public PSObject linkedRoutemapOut { get; set; }
		public bool nexthopself { get; set; }
		public int remoteas { get; set; }
		public PSObject updatesource { get; set; }
		#endregion Parameters

		public BGPNeighbor () {
			address = null;
			defaultoriginate = false;
			enabled = false;
			linkedPrefixlistIn = null;
			linkedPrefixlistOut = null;
			linkedRoutemapIn = null;
			linkedRoutemapOut = null;
			nexthopself = false;
			remoteas = 0;
			updatesource = null;
		}

		public BGPNeighbor (
			string Address,
			bool Defaultoriginate,
			bool Enabled,
			PSObject LinkedPrefixlistIn,
			PSObject LinkedPrefixlistOut,
			PSObject LinkedRoutemapIn,
			PSObject LinkedRoutemapOut,
			bool Nexthopself,
			int Remoteas,
			PSObject Updatesource
		) {
			address = Address;
			defaultoriginate = Defaultoriginate;
			enabled = Enabled;
			linkedPrefixlistIn = LinkedPrefixlistIn;
			linkedPrefixlistOut = LinkedPrefixlistOut;
			linkedRoutemapIn = LinkedRoutemapIn;
			linkedRoutemapOut = LinkedRoutemapOut;
			nexthopself = Nexthopself;
			remoteas = Remoteas;
			updatesource = Updatesource;
		}
	}
	public class BGPPrefixlist {
		#region Parameters
		public PSObject action { get; set; }
		public bool enabled { get; set; }
		public string name { get; set; }
		public string network { get; set; }
		public int seqnumber { get; set; }
		#endregion Parameters

		public BGPPrefixlist () {
			action = null;
			enabled = false;
			name = null;
			network = null;
			seqnumber = 0;
		}

		public BGPPrefixlist (
			PSObject Action,
			bool Enabled,
			string Name,
			string Network,
			int Seqnumber
		) {
			action = Action;
			enabled = Enabled;
			name = Name;
			network = Network;
			seqnumber = Seqnumber;
		}
	}
	public class BGPRoutemap {
		#region Parameters
		public PSObject action { get; set; }
		public bool enabled { get; set; }
		public int id { get; set; }
		public PSObject match { get; set; }
		public string name { get; set; }
		public string set { get; set; }
		#endregion Parameters

		public BGPRoutemap () {
			action = null;
			enabled = false;
			id = 0;
			match = null;
			name = null;
			set = null;
		}

		public BGPRoutemap (
			PSObject Action,
			bool Enabled,
			int Id,
			PSObject Match,
			string Name,
			string Set
		) {
			action = Action;
			enabled = Enabled;
			id = Id;
			match = Match;
			name = Name;
			set = Set;
		}
	}
	public class Ospf6Interface {
		#region Parameters
		public string area { get; set; }
		public int cost { get; set; }
		public int deadinterval { get; set; }
		public bool enabled { get; set; }
		public int hellointerval { get; set; }
		public PSObject interfacename { get; set; }
		public PSObject networktype { get; set; }
		public int priority { get; set; }
		public int retransmitinterval { get; set; }
		public int transmitdelay { get; set; }
		#endregion Parameters

		public Ospf6Interface () {
			area = null;
			cost = 0;
			deadinterval = 0;
			enabled = false;
			hellointerval = 0;
			interfacename = null;
			networktype = null;
			priority = 0;
			retransmitinterval = 0;
			transmitdelay = 0;
		}

		public Ospf6Interface (
			string Area,
			int Cost,
			int Deadinterval,
			bool Enabled,
			int Hellointerval,
			PSObject Interfacename,
			PSObject Networktype,
			int Priority,
			int Retransmitinterval,
			int Transmitdelay
		) {
			area = Area;
			cost = Cost;
			deadinterval = Deadinterval;
			enabled = Enabled;
			hellointerval = Hellointerval;
			interfacename = Interfacename;
			networktype = Networktype;
			priority = Priority;
			retransmitinterval = Retransmitinterval;
			transmitdelay = Transmitdelay;
		}
	}
	public class OspfInterface {
		#region Parameters
		public string authkey { get; set; }
		public PSObject authtype { get; set; }
		public int cost { get; set; }
		public int deadinterval { get; set; }
		public bool enabled { get; set; }
		public int hellointerval { get; set; }
		public PSObject interfacename { get; set; }
		public PSObject networktype { get; set; }
		public int priority { get; set; }
		public int retransmitinterval { get; set; }
		public int transmitdelay { get; set; }
		#endregion Parameters

		public OspfInterface () {
			authkey = null;
			authtype = null;
			cost = 0;
			deadinterval = 0;
			enabled = false;
			hellointerval = 0;
			interfacename = null;
			networktype = null;
			priority = 0;
			retransmitinterval = 0;
			transmitdelay = 0;
		}

		public OspfInterface (
			string Authkey,
			PSObject Authtype,
			int Cost,
			int Deadinterval,
			bool Enabled,
			int Hellointerval,
			PSObject Interfacename,
			PSObject Networktype,
			int Priority,
			int Retransmitinterval,
			int Transmitdelay
		) {
			authkey = Authkey;
			authtype = Authtype;
			cost = Cost;
			deadinterval = Deadinterval;
			enabled = Enabled;
			hellointerval = Hellointerval;
			interfacename = Interfacename;
			networktype = Networktype;
			priority = Priority;
			retransmitinterval = Retransmitinterval;
			transmitdelay = Transmitdelay;
		}
	}
	public class OspfNetwork {
		#region Parameters
		public string area { get; set; }
		public bool enabled { get; set; }
		public string ipaddr { get; set; }
		public PSObject linkedPrefixlistIn { get; set; }
		public PSObject linkedPrefixlistOut { get; set; }
		public int netmask { get; set; }
		#endregion Parameters

		public OspfNetwork () {
			area = null;
			enabled = false;
			ipaddr = null;
			linkedPrefixlistIn = null;
			linkedPrefixlistOut = null;
			netmask = 0;
		}

		public OspfNetwork (
			string Area,
			bool Enabled,
			string Ipaddr,
			PSObject LinkedPrefixlistIn,
			PSObject LinkedPrefixlistOut,
			int Netmask
		) {
			area = Area;
			enabled = Enabled;
			ipaddr = Ipaddr;
			linkedPrefixlistIn = LinkedPrefixlistIn;
			linkedPrefixlistOut = LinkedPrefixlistOut;
			netmask = Netmask;
		}
	}
	public class OspfPrefixlist {
		#region Parameters
		public PSObject action { get; set; }
		public bool enabled { get; set; }
		public string name { get; set; }
		public string network { get; set; }
		public int seqnumber { get; set; }
		#endregion Parameters

		public OspfPrefixlist () {
			action = null;
			enabled = false;
			name = null;
			network = null;
			seqnumber = 0;
		}

		public OspfPrefixlist (
			PSObject Action,
			bool Enabled,
			string Name,
			string Network,
			int Seqnumber
		) {
			action = Action;
			enabled = Enabled;
			name = Name;
			network = Network;
			seqnumber = Seqnumber;
		}
	}
}
