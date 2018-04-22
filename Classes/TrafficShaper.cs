﻿using System;
using System.Management.Automation;

namespace OPNsense.TrafficShaper {
	public class Pipe {
		#region Parameters
		public int bandwidth { get; set; }
		public PSObject bandwidthMetric { get; set; }
		public int buckets { get; set; }
		public bool codel_ecn_enable { get; set; }
		public bool codel_enable { get; set; }
		public int codel_interval { get; set; }
		public int codel_target { get; set; }
		public int delay { get; set; }
		public string description { get; set; }
		public bool enabled { get; set; }
		public int fqcodel_flows { get; set; }
		public int fqcodel_limit { get; set; }
		public int fqcodel_quantum { get; set; }
		public PSObject mask { get; set; }
		public int number { get; set; }
		public string origin { get; set; }
		public int queue { get; set; }
		public PSObject scheduler { get; set; }
		#endregion Parameters

		public Pipe () {
			bandwidth = 0;
			bandwidthMetric = null;
			buckets = 0;
			codel_ecn_enable = false;
			codel_enable = false;
			codel_interval = 0;
			codel_target = 0;
			delay = 0;
			description = null;
			enabled = false;
			fqcodel_flows = 0;
			fqcodel_limit = 0;
			fqcodel_quantum = 0;
			mask = null;
			number = 0;
			origin = null;
			queue = 0;
			scheduler = null;
		}

		public Pipe (
			int Bandwidth,
			PSObject BandwidthMetric,
			int Buckets,
			bool Codel_Ecn_Enable,
			bool Codel_Enable,
			int Codel_Interval,
			int Codel_Target,
			int Delay,
			string Description,
			bool Enabled,
			int Fqcodel_Flows,
			int Fqcodel_Limit,
			int Fqcodel_Quantum,
			PSObject Mask,
			int Number,
			string Origin,
			int Queue,
			PSObject Scheduler
		) {
			bandwidth = Bandwidth;
			bandwidthMetric = BandwidthMetric;
			buckets = Buckets;
			codel_ecn_enable = Codel_Ecn_Enable;
			codel_enable = Codel_Enable;
			codel_interval = Codel_Interval;
			codel_target = Codel_Target;
			delay = Delay;
			description = Description;
			enabled = Enabled;
			fqcodel_flows = Fqcodel_Flows;
			fqcodel_limit = Fqcodel_Limit;
			fqcodel_quantum = Fqcodel_Quantum;
			mask = Mask;
			number = Number;
			origin = Origin;
			queue = Queue;
			scheduler = Scheduler;
		}
	}
	public class Queue {
		#region Parameters
		public int buckets { get; set; }
		public bool codel_ecn_enable { get; set; }
		public bool codel_enable { get; set; }
		public int codel_interval { get; set; }
		public int codel_target { get; set; }
		public string description { get; set; }
		public bool enabled { get; set; }
		public PSObject mask { get; set; }
		public int number { get; set; }
		public string origin { get; set; }
		public PSObject pipe { get; set; }
		public int weight { get; set; }
		#endregion Parameters

		public Queue () {
			buckets = 0;
			codel_ecn_enable = false;
			codel_enable = false;
			codel_interval = 0;
			codel_target = 0;
			description = null;
			enabled = false;
			mask = null;
			number = 0;
			origin = null;
			pipe = null;
			weight = 0;
		}

		public Queue (
			int Buckets,
			bool Codel_Ecn_Enable,
			bool Codel_Enable,
			int Codel_Interval,
			int Codel_Target,
			string Description,
			bool Enabled,
			PSObject Mask,
			int Number,
			string Origin,
			PSObject Pipe,
			int Weight
		) {
			buckets = Buckets;
			codel_ecn_enable = Codel_Ecn_Enable;
			codel_enable = Codel_Enable;
			codel_interval = Codel_Interval;
			codel_target = Codel_Target;
			description = Description;
			enabled = Enabled;
			mask = Mask;
			number = Number;
			origin = Origin;
			pipe = Pipe;
			weight = Weight;
		}
	}
	public class Rule {
		#region Parameters
		public string description { get; set; }
		public PSObject destination { get; set; }
		public bool destination_not { get; set; }
		public PSObject direction { get; set; }
		public PSObject dst_port { get; set; }
		public PSObject Interface { get; set; }
		public PSObject interface2 { get; set; }
		public string origin { get; set; }
		public PSObject proto { get; set; }
		public int sequence { get; set; }
		public PSObject source { get; set; }
		public bool source_not { get; set; }
		public PSObject src_port { get; set; }
		public PSObject target { get; set; }
		#endregion Parameters

		public Rule () {
			description = null;
			destination = null;
			destination_not = false;
			direction = null;
			dst_port = null;
			Interface = null;
			interface2 = null;
			origin = null;
			proto = null;
			sequence = 0;
			source = null;
			source_not = false;
			src_port = null;
			target = null;
		}

		public Rule (
			string Description,
			PSObject Destination,
			bool Destination_Not,
			PSObject Direction,
			PSObject Dst_Port,
			PSObject Interface_,
			PSObject Interface2,
			string Origin,
			PSObject Proto,
			int Sequence,
			PSObject Source,
			bool Source_Not,
			PSObject Src_Port,
			PSObject Target
		) {
			description = Description;
			destination = Destination;
			destination_not = Destination_Not;
			direction = Direction;
			dst_port = Dst_Port;
			Interface = Interface_;
			interface2 = Interface2;
			origin = Origin;
			proto = Proto;
			sequence = Sequence;
			source = Source;
			source_not = Source_Not;
			src_port = Src_Port;
			target = Target;
		}
	}
}
