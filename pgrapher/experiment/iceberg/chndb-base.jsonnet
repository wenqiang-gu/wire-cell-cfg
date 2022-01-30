// Base channel noise DB object configuration for microboone
// This does not include any run dependent RMS cuts.
// See chndb.jsonnet

// local handmade = import 'chndb-resp.jsonnet';
local wc = import 'wirecell.jsonnet';

function(params, anode, field, n, rms_cuts=[])
  {
    anode: wc.tn(anode),
    field_response: wc.tn(field),

    tick: params.daq.tick,

    // This sets the number of frequency-domain bins used in the noise
    // filtering.  It is expected that time-domain waveforms have the
    // same number of samples.
    nsamples: params.nf.nsamples,

    // For MicroBooNE, channel groups is a 2D list.  Each element is
    // one group of channels which should be considered together for
    // coherent noise filtering.
    // groups: [std.range(g*48, (g+1)*48-1) for g in std.range(0,171)],
    /* groups: [std.range(n * 2560 + u * 40, n * 2560 + (u + 1) * 40 - 1) for u in std.range(0, 19)]
            + [std.range(n * 2560 + 800 + v * 40, n * 2560 + 800 + (v + 1) * 40 - 1) for v in std.range(0, 19)]
            + [std.range(n * 2560 + 1600 + w * 48, n * 2560 + 1600 + (w + 1) * 48 - 1) for w in std.range(0, 19)],*/


    // Externally determined "bad" channels.
    // bad: [4411, 4412, 9990, 11842, 1, 400, 401, 800, 801, 876, 1200, 2961, 5321, 5363, 6132, 7058, 7295, 7681, 8080, 8328, 8480, 9282, 9283, 9736, 9854, 10800, 11024, 11457, 11459, 11463, 11469, 11517, 11669, 11679, 12756, 12801, 13001, 13081, 4410, 1719, 5125, 7551, 7190, 7194, 7918, 2, 7680, 5361, 4, 1632, 2169, 3541, 3543, 3661, 3663, 4061, 4063, 4141, 4143, 4377, 4379, 4381, 4383, 4385, 4387, 4521, 4523, 4525, 4527, 4529, 4531, 4652, 4654, 4656, 4658, 4660, 4658, 4748, 4750, 4752, 4754, 4756, 4758, 8501, 8503, 8821, 8823, 9261, 9263, 9305, 9307, 9309, 9311, 9313, 9315, 9689, 9691, 9693, 9695, 9697, 9699, 9772, 9774, 9776, 9778, 9780, 9782, 10102, 10189, 10697, 10907, 11203, 11270, 11902, 12324, 12333, 12744, 13363, 200, 202, 204, 206, 208, 991, 993, 995, 997, 999, 1829, 1831, 1833, 1835, 1837, 1839],

    // Overide defaults for specific channels.  If an info is
    // mentioned for a particular channel in multiple objects in this
    // list then last mention wins.
    channel_info: [

      // First entry provides default channel info across ALL
      // channels.  Subsequent entries override a subset of channels
      // with a subset of these entries.  There's no reason to
      // repeat values found here in subsequent entries unless you
      // wish to change them.
      {
        channels: std.range(n * 1280, (n + 1) * 1280 - 1),
        nominal_baseline: 2048.0,  // adc count
        gain_correction: 1.0,  // unitless
        response_offset: 0.0,  // ticks?
        pad_window_front: 10,  // ticks?
        pad_window_back: 10,  // ticks?
        decon_limit: 0.02,
        decon_limit1: 0.09,
        adc_limit: 15,
        min_rms_cut: 1.0,  // units???
        max_rms_cut: 30.0,  // units???

        // parameter used to make "rcrc" spectrum
        rcrc: 1.1 * wc.millisecond, // 1.1 for collection, 3.3 for induction
        rc_layers: 1, // default 2

        // parameters used to make "config" spectrum
        reconfig: {},

        // list to make "noise" spectrum mask
        freqmasks: [],

        // field response waveform to make "response" spectrum.
        response: {},

      },

/*      {
        //channels: { wpid: wc.WirePlaneId(wc.Ulayer) },
	channels: std.range(n * 2560, n * 2560 + 800- 1),
	freqmasks: [
          { value: 1.0, lobin: 0, hibin: $.nsamples - 1 },
          { value: 0.0, lobin: 169, hibin: 173 },
          { value: 0.0, lobin: 513, hibin: 516 },
        ],
        /// this will use an average calculated from the anode
        // response: { wpid: wc.WirePlaneId(wc.Ulayer) },
        /// this uses hard-coded waveform.
        response: { waveform: handmade.u_resp, waveformid: wc.Ulayer },
        response_offset: 149,
        pad_window_front: 20,
        decon_limit: 0.02,
        decon_limit1: 0.09,
      },

      {
        //channels: { wpid: wc.WirePlaneId(wc.Vlayer) },
	channels: std.range(n * 2560 + 800, n * 2560 + 1600- 1),
        freqmasks: [
          { value: 1.0, lobin: 0, hibin: $.nsamples - 1 },
          { value: 0.0, lobin: 169, hibin: 173 },
          { value: 0.0, lobin: 513, hibin: 516 },
        ],
        /// this will use an average calculated from the anode
        // response: { wpid: wc.WirePlaneId(wc.Vlayer) },
        /// this uses hard-coded waveform.
        response: { waveform: handmade.v_resp, waveformid: wc.Vlayer },
        response_offset: 155,
        decon_limit: 0.01,
        decon_limit1: 0.08,
      },

      {
        //channels: { wpid: wc.WirePlaneId(wc.Wlayer) },
	channels: std.range(n * 2560 + 1600, n * 2560 + 2560- 1),
        nominal_baseline: 400.0,
        decon_limit: 0.05,
        decon_limit1: 0.08,
      },

      // {                       // special channel
      //     channels: 2240,
      //     freqmasks: [
      //         { value: 1.0, lobin: 0, hibin: $.nsamples-1 },
      //         { value: 0.0, lobin: 169, hibin: 173 },
      //         { value: 0.0, lobin: 513, hibin: 516 },
      //         { value: 0.0, lobin:  17, hibin:  19 },
      //     ],
      // },

      // {                       // these are before hardware fix
      //     channels: params.nf.misconfigured.channels,
      //     reconfig: {
      //         from: {gain:  params.nf.misconfigured.gain,
      //                shaping: params.nf.misconfigured.shaping},
      //         to:   {gain: params.elec.gain,
      //                shaping: params.elec.shaping},
      //     }
      // },
*/
    ] + rms_cuts,
  }
