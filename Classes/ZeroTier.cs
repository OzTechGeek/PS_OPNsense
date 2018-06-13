﻿using System;
using System.Management.Automation;

namespace OPNsense.zerotier.networks {
	public class Network {
		#region Parameters
		public string description { get; set; }
		public bool enabled { get; set; }
		public string networkId { get; set; }
		#endregion Parameters

		public Network () {
			description = null;
			enabled = true;
			networkId = null;
		}

		public Network (
			string Description,
			byte Enabled,
			string NetworkId
		) {
			description = Description;
			enabled = (Enabled == 0) ? false : true;
			networkId = NetworkId;
		}
	}
}
