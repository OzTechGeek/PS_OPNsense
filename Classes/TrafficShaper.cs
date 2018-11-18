using System;
using System.Management.Automation;

namespace OPNsense.TrafficShaper.pipes {
	public class Pipe {
		#region Parameters
		public uint bandwidth { get; set; }
		public PSObject bandwidthMetric { get; set; }
		public uint16 buckets { get; set; }
		public bool codel_ecn_enable { get; set; }
		public bool codel_enable { get; set; }
		public uint16 codel_interval { get; set; }
		public uint16 codel_target { get; set; }
		public uint16 delay { get; set; }
		public string description { get; set; }
		public bool enabled { get; set; }
		public uint16 fqcodel_flows { get; set; }
		public uint16 fqcodel_limit { get; set; }
		public uint16 fqcodel_quantum { get; set; }
		public PSObject mask { get; set; }
		public uint16 number { get; set; }
		public string origin { get; set; }
		public bool pie_enable { get; set; }
		public byte queue { get; set; }
		public PSObject scheduler { get; set; }
		#endregion Parameters

		public Pipe () {
			bandwidth = 0;
			bandwidthMetric = null;
			buckets = 0;
			codel_ecn_enable = true;
			codel_enable = true;
			codel_interval = 0;
			codel_target = 0;
			delay = 0;
			description = null;
			enabled = true;
			fqcodel_flows = 0;
			fqcodel_limit = 0;
			fqcodel_quantum = 0;
			mask = null;
			number = 0;
			origin = null;
			pie_enable = true;
			queue = 0;
			scheduler = null;
		}

		public Pipe (
			uint Bandwidth,
			PSObject BandwidthMetric,
			uint16 Buckets,
			byte Codel_Ecn_Enable,
			byte Codel_Enable,
			uint16 Codel_Interval,
			uint16 Codel_Target,
			uint16 Delay,
			string Description,
			byte Enabled,
			uint16 Fqcodel_Flows,
			uint16 Fqcodel_Limit,
			uint16 Fqcodel_Quantum,
			PSObject Mask,
			uint16 Number,
			string Origin,
			byte Pie_Enable,
			byte Queue,
			PSObject Scheduler
		) {
			bandwidth = Bandwidth;
			bandwidthMetric = BandwidthMetric;
			buckets = Buckets;
			codel_ecn_enable = (Codel_Ecn_Enable == 0) ? false : true;
			codel_enable = (Codel_Enable == 0) ? false : true;
			codel_interval = Codel_Interval;
			codel_target = Codel_Target;
			delay = Delay;
			description = Description;
			enabled = (Enabled == 0) ? false : true;
			fqcodel_flows = Fqcodel_Flows;
			fqcodel_limit = Fqcodel_Limit;
			fqcodel_quantum = Fqcodel_Quantum;
			mask = Mask;
			number = Number;
			origin = Origin;
			pie_enable = (Pie_Enable == 0) ? false : true;
			queue = Queue;
			scheduler = Scheduler;
		}
	}
}
namespace OPNsense.TrafficShaper.queues {
	public class Queue {
		#region Parameters
		public uint16 buckets { get; set; }
		public bool codel_ecn_enable { get; set; }
		public bool codel_enable { get; set; }
		public uint16 codel_interval { get; set; }
		public uint16 codel_target { get; set; }
		public string description { get; set; }
		public bool enabled { get; set; }
		public PSObject mask { get; set; }
		public uint16 number { get; set; }
		public string origin { get; set; }
		public bool pie_enable { get; set; }
		public PSObject pipe { get; set; }
		public byte weight { get; set; }
		#endregion Parameters

		public Queue () {
			buckets = 0;
			codel_ecn_enable = true;
			codel_enable = true;
			codel_interval = 0;
			codel_target = 0;
			description = null;
			enabled = true;
			mask = null;
			number = 0;
			origin = null;
			pie_enable = true;
			pipe = null;
			weight = 100;
		}

		public Queue (
			uint16 Buckets,
			byte Codel_Ecn_Enable,
			byte Codel_Enable,
			uint16 Codel_Interval,
			uint16 Codel_Target,
			string Description,
			byte Enabled,
			PSObject Mask,
			uint16 Number,
			string Origin,
			byte Pie_Enable,
			PSObject Pipe,
			byte Weight
		) {
			buckets = Buckets;
			codel_ecn_enable = (Codel_Ecn_Enable == 0) ? false : true;
			codel_enable = (Codel_Enable == 0) ? false : true;
			codel_interval = Codel_Interval;
			codel_target = Codel_Target;
			description = Description;
			enabled = (Enabled == 0) ? false : true;
			mask = Mask;
			number = Number;
			origin = Origin;
			pie_enable = (Pie_Enable == 0) ? false : true;
			pipe = Pipe;
			weight = Weight;
		}
	}
}
namespace OPNsense.TrafficShaper.rules {
	public class Rule {
		#region Parameters
		public string description { get; set; }
		public PSObject destination { get; set; }
		public bool destination_not { get; set; }
		public PSObject direction { get; set; }
		public PSObject dst_port { get; set; }
		public bool enabled { get; set; }
		public PSObject Interface { get; set; }
		public PSObject interface2 { get; set; }
		public string origin { get; set; }
		public PSObject proto { get; set; }
		public uint sequence { get; set; }
		public PSObject source { get; set; }
		public bool source_not { get; set; }
		public PSObject src_port { get; set; }
		public PSObject target { get; set; }
		#endregion Parameters

		public Rule () {
			description = null;
			destination = null;
			destination_not = true;
			direction = null;
			dst_port = null;
			enabled = true;
			Interface = null;
			interface2 = null;
			origin = null;
			proto = null;
			sequence = 1;
			source = null;
			source_not = true;
			src_port = null;
			target = null;
		}

		public Rule (
			string Description,
			PSObject Destination,
			byte Destination_Not,
			PSObject Direction,
			PSObject Dst_Port,
			byte Enabled,
			PSObject Interface_,
			PSObject Interface2,
			string Origin,
			PSObject Proto,
			uint Sequence,
			PSObject Source,
			byte Source_Not,
			PSObject Src_Port,
			PSObject Target
		) {
			description = Description;
			destination = Destination;
			destination_not = (Destination_Not == 0) ? false : true;
			direction = Direction;
			dst_port = Dst_Port;
			enabled = (Enabled == 0) ? false : true;
			Interface = Interface_;
			interface2 = Interface2;
			origin = Origin;
			proto = Proto;
			sequence = Sequence;
			source = Source;
			source_not = (Source_Not == 0) ? false : true;
			src_port = Src_Port;
			target = Target;
		}
	}
}
