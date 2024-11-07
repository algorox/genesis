// increase number of buffers and memory allocation for Genesis

	~bufferSet = Server.local.options;
	~bufferSet.numWireBufs = 512;
	~bufferSet.memSize = 128000;

// Wrap startup of Genesis as a task

~startupTask = Routine({

	1.do({arg i;

	{

// Set GUI to QT and create load window
	GUI.qt;
	~loadWindow = Window("Loading", Rect((1920/3), 456, (1920/3), 230 ), false, false, scroll: false);
	~loadText = StaticText(~loadWindow, Rect(170, 40 , (1920/6), 40));
	~loadText.stringColor = Color.white.alpha_(0.5);
	~loadText.font_(Font("Monaco", 28));
	~loadWindow.view.background = Color.gray.alpha_(0.3);
	~loadWindow.alwaysOnTop = true;
	~loadWindow.front;
	~connectTest = -1;
	~loadPosition0 = 0;

// Create audio buffers for various FFT processes and Granluar Synthesizers, along with the control busses and audio busses

	~osc0OnsetBuffer0 = Array.new(13);
	~osc0OnsetBufferArray0 = Array.fill(13, {arg i;
	~osc0OnsetBuffer0.add(Buffer.alloc(s, 1024, 1, bufnum:(300 + (i*2))));
	});

	~osc1OnsetBuffer0 = Array.new(13);
	~osc1OnsetBufferArray0 = Array.fill(13, {arg i;
	~osc1OnsetBuffer0.add(Buffer.alloc(s, 1024, 1, bufnum:(400 + (i*2))));
	});

	~feedback0OnsetBuffer0 = Array.new(13);
	~feedback0OnsetBufferArray0 = Array.fill(13, {arg i;
	~feedback0OnsetBuffer0.add(Buffer.alloc(s, 1024, 1, bufnum:(500 + (i*2))));
	});

	~warpBuffer0 = Array.new(13);
	~warpBufferArray0 = Array.fill(13, {arg i;
	~warpBuffer0.add(Buffer.alloc(s, (s.sampleRate) * 4, 1, bufnum:(1008 + (i * 2))));
	});

	~warpBuffer1 = Array.new(13);
	~warpBufferArray1 = Array.fill(13, {arg i;
	~warpBuffer1.add(Buffer.alloc(s, (s.sampleRate) * 4, 1, bufnum:(1122 + (i * 2))));
	});

	~warpBuffer2 = Array.new(13);
	~warpBufferArray2 = Array.fill(13, {arg i;
	~warpBuffer2.add(Buffer.alloc(s, (s.sampleRate) * 4, 1, bufnum:(1200 + (i * 2))));
	});

	~pitchBuffer0 = Array.new(39);
	~pitchBufferArray0 = Array.fill(39, {arg i;
	~pitchBuffer0.add(Buffer.alloc(s, 2048, 1, bufnum:(700 + (i))));
	});

	~gui0Bus0 = Bus.control(s, 63);
	~mfccBus0 = Bus.control(s, 13);
	~mfccBus1 = Bus.control(s, 13);
	~mfccBus2 = Bus.control(s, 13);
	~trigger0Bus0 = Bus.control(s,13);
	~trigger1Bus0 = Bus.control(s,13);
	~threshold0Bus0 = Bus.control(s,13);
	~threshold1Bus0 = Bus.control(s,13);
	~position0Bus0 = Bus.control(s,3);
	~grainGuiTriggerBus0 = Bus.control(s, 13);
	~envelopeBus0 = Bus.control(s, 13);
	~envelopeBus1 = Bus.control(s, 13);
	~envelopeBus2 = Bus.control(s, 13);
	~controlTempoBus0 = Bus.control(s, 3);
	~onset0Bus0 = Bus.control(s, 13);
	~onset1Bus0 = Bus.control(s, 13);
	~onset2Bus0 = Bus.control(s, 13);
	~duration0Bus0 = Bus.control(s, 13);
	~duration1Bus0 = Bus.control(s, 13);
	~duration2Bus0 = Bus.control(s, 13);
	~grainPositionBus0 = Bus.control(s, 13);
	~grainPositionBus1 = Bus.control(s, 13);
	~grainPositionBus2 = Bus.control(s, 13);
	~freezeBus0 = Bus.control(s, 13);
	~freezeBus1 = Bus.control(s, 13);
	~freezeBus2 = Bus.control(s, 13);
	~pan0Bus0 = Bus.control(s, 13);
	~pan1Bus0 = Bus.control(s, 13);
	~pan2Bus0 = Bus.control(s, 13);
	~guiEnvelopeBus0 = Bus.control(s, 39);
	~guiEnvelopeBus1 = Bus.control(s, 39);
	~grainPitch0Bus0 = Bus.control(s, 13);
	~grainPitch1Bus0 = Bus.control(s, 13);
	~grainPitch2Bus0 = Bus.control(s, 13);
	~scaleControl0 = Bus.control(s, 3);
	~filterTracker0 = Bus.control(s, 13);
	~filterTracker1 = Bus.control(s, 13);
	~filterTracker2 = Bus.control(s, 13);
	~filterFreqBus0 = Bus.control(s, 13);
	~filterFreqBus1 = Bus.control(s, 13);
	~filterFreqBus2 = Bus.control(s, 13);
	~powersBus0 = Bus.control(s, 3);

	~bufferBus0 = Bus.audio(s,1);
	~bufferBus1 = Bus.audio(s,1);
	~bufferBus2 = Bus.audio(s,1);
	~synthBus0 = Bus.audio(s,1);
	~synthBus1 = Bus.audio(s,1);
	~synthBus2 = Bus.audio(s,1);
	~soundInputBus0 = Bus.audio(s,1);
	~soundInputBus1 = Bus.audio(s,1);
	~fxBus0 = Bus.audio(s,2);
	~tempo0Bus0 = Bus.audio(s,2);
	~osc0Bus0 = Bus.audio(s,2);
	~osc1Bus0 = Bus.audio(s,2);
	~osc2Bus0 = Bus.audio(s,2);
	~grain0Bus0 = Bus.audio(s,2);
	~grain1Bus0 = Bus.audio(s,2);
	~grain2Bus0 = Bus.audio(s,2);
	~scaleBusOut0 = Bus.audio(s,1);
	~scaleSend0 = Bus.audio(s,1);
	~triggerOut0 = Bus.audio(s,13);
	~triggerOut1 = Bus.audio(s,13);
	~triggerOut2 = Bus.audio(s,13);

	~fftBuffer0 = Buffer.alloc(s,1024,1, bufnum:200);
	~fftBuffer1 = Buffer.alloc(s,1024,1, bufnum:202);
	~fftBuffer2 = Buffer.alloc(s,1024,1, bufnum:204);
	~mfccBuffer0 = Buffer.alloc(s, 1024,1, 1, bufnum:206);
	~mfccBuffer1 = Buffer.alloc(s, 1024,1, 1, bufnum:208);
	~mfccBuffer2 = Buffer.alloc(s, 1024,1, bufnum:210);
	~powerBuffer0 = Buffer.alloc(s, 1024,1, bufnum:212);
	~powerBuffer1 = Buffer.alloc(s, 1024,1, bufnum:214);
	~powerBuffer2 = Buffer.alloc(s, 1024,1, bufnum:216);
	~powerBuffer3 = Buffer.alloc(s, 1024,1, bufnum:218);
	~inputBuffer = Buffer.alloc(s, s.sampleRate, 2, bufnum:222);
	~recordBuffer0 = Buffer.alloc(s, s.sampleRate, 2, bufnum:226);
	~interactBuffer0 = Buffer.alloc(s, s.sampleRate * 60, 2, bufnum:228);

// Loading graphic routine

	~loadCircle = UserView(~loadWindow, Rect(0, 0, 1920/3, 230));
	~loadCircle.drawFunc = {
			Pen.translate(~loadPosition0.min(1920/3), 125);
			1.do{
				Pen.color = Color.yellow.alpha_(0.6);
				Pen.addWedge((100)@(40), 50, 2pi, 2pi);
				Pen.perform(\fill);
			};

			1.do{
				Pen.color = Color.red.alpha_(0.6);
				Pen.addWedge((165)@(40), 50, 2pi, 2pi);
				Pen.perform(\fill);
			};

			1.do{
				Pen.color = Color.blue.alpha_(0.6);
				Pen.addWedge((230)@(40), 50, 2pi, 2pi);
				Pen.perform(\fill);
			};

			};

	~loadTask = Task({
		inf.do({arg i;

	~loadPosition0 = i * 10;
	{
	~loadText.string = "Genesis Loading.  ";

	~loadWindow.refresh;
	}.defer;

	(0.05).wait;

	~loadPosition0 = i * 10;

	{
	~loadText.string = "Genesis Loading.. ";

	~loadWindow.refresh;

	}.defer;
	(0.05).wait;

	~loadPosition0 = i * 10;

	{
	~loadText.string = "Genesis Loading...";

	~loadWindow.refresh;
	}.defer;
	(0.05).wait;
	});
	}).play;
	}.defer;

	1.wait;

// Set GUI to Cocoa

	GUI.cocoa;

	{

// Set variables for bus collection and selected GUI objects

	var mfccReverseBreed = [], envelopeReverseBreed = [], durationReverseBreed0 = [], onsetReverseBreed0 = [], panReverseBreed0 = [], pitchReverseBreed0 = [], revData0 = [], grainTriggerNetwork = [], triggers0Network = [], triggers1Network = [], filters0Network = [], filters1Network = [], filters2Network = [];

	var panSpec0, power0 = 0, power1 = 0, power2 = 0, pitchNetworkOut0 = 0, pitchNetworkOut1 = 0;

	var mfccGenomeA, mfccGenomeB, mfccCrossover, mfccBreed = [0,0,0,0,0,0,0,0,0,0,0,0,0], mfccData0, mfccData1, crossover0 = 0.1, mutation0 = 0.1;

	var envelopeGenomeA, envelopeGenomeB, envelopeCrossover, envelopeBreed = [0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0], crossover1 = 0.1, mutation1 = 0.1, envelopeData0, envelopeData1;

	var onset0GenomeA, onset0GenomeB, onset0Data0, onset1Data0, onset0Breed0 = [0,0,0,0,0,0,0,0,0,0,0,0,0], onset0Crossover0, onset0CrossoverRate0 = 0.1, onset0Mutation0 = 0.1, envelope0Data0, envelope1Data0, envelope2Data0, position0Data0, position1Data0, position2Data0, freezeData0, freezeData1, freezeData2, filterFreqData0,  filterFreqData1,  filterFreqData2;

	var duration0GenomeA, duration0GenomeB, duration0Data0, duration1Data0, duration2Data0, duration0Breed0 = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], duration0Crossover0, duration0CrossoverRate0 = 0.1, duration0Mutation0 = 0.1, grainsVolume0 = 0, grainsVolume1 = 0, grainsVolume2 = 0, freezeVolume0 = 0, freezeVolume1 = 0, freezeVolume2 = 0;

	var pan0GenomeA, pan0GenomeB, pan0Data0, pan1Data0, pan2Data0, pan0Breed0 = [0,0,0,0,0,0,0,0,0,0,0,0,0], pan0Crossover0, pan0CrossoverRate0 = 0.1, pan0Mutation0 = 0.1;

	var pitch0GenomeA, pitch0GenomeB, pitch0Data0, pitch1Data0, pitch2Data0, pitch0Breed0 = [1,1,1,1,1,1,1,1,1,1,1,1,1], pitch0Crossover0, pitch0CrossoverRate0 = 0.1, pitch0Mutation0 = 0.1;

	var attack00 = 0, attack01 = 0, attack02 = 0, c0 = 0,e0 = 0, g0 = 0, syncOut = 0;

	var scale = ["A3", "A3", "A3", "A3", "A3", "A3", "A3", "A3"],  scaleSetButton, scaleMessage0 = 1, scaleMessage1 = 1, scaleMessage2 = 440, scaleMessage3 = 440;

	var width = 300, height = 300,

	osc0View0,
	envelopeViewer0, envelopeArray0, guiUpdateRoutine0, osc1View0, pitchText1, attackTextArray0, save0ButtonArray0, load0ButtonArray0, loadData0, beatUpdateSlider0, oscData0Slider1, mfccData2, mfccDataSlider2, resSpec0, volume1Spec0, barLengthSpec, spectrumOn0 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0], spectrumOn1 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0], spectrumOn2 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0];

	~samplePath0 = "";
	~cnumFrames = 0;
	~samplePath1 = "";
	~dnumFrames = 0;
	~samplePath2 = "";
	~bnumFrames = 0;

// Create buffers for Sample UGens

	b = Buffer.readChannel(s, ~samplePath0.asString, channels:[0], bufnum:100);
	c = Buffer.readChannel(s, ~samplePath0.asString, channels:[0], bufnum:103);
	d = Buffer.readChannel(s, ~samplePath0.asString, channels:[0], bufnum:105);

// various variables for GUI and bus functions

	~length = 1;
	~start = 0;

	~trigger0Reply = [0,0,0,0,0,0,0,0,0,0,0,0,0];
	~trigger1Reply = [0,0,0,0,0,0,0,0,0,0,0,0,0];
	~grainTriggerReply = [0,0,0,0,0,0,0,0,0,0,0,0,0];
	~pitchReply0 = [0,0,0];
	~filter0Reply = [0,0,0,0,0,0,0,0,0,0,0,0,0];
	~filter1Reply = [0,0,0,0,0,0,0,0,0,0,0,0,0];
	~filter2Reply = [0,0,0,0,0,0,0,0,0,0,0,0,0];
	~mfccData0Reply = [0,0,0,0,0,0,0,0,0,0,0,0,0,0];
	~mfccData1Reply = [0,0,0,0,0,0,0,0,0,0,0,0,0,0];
	~mfccData2Reply = [0,0,0,0,0,0,0,0,0,0,0,0,0];
	~clockReply0 = [0,0,0];
	~systemReply0 = [0,0,0,0,0,0,0,0,0,0,0];
	~networkSampleChange0 = 0;
	~networkSampleSelector0 = 0;
	~networkRecord0 = 0;
	~recordNetworkLength0 = 1.0;
	~quickLoadNetworkValue = 0;
	~quickLoadNetworkOn = 0;
	~networkInputSelector0 = 0;
	~networkInputSelector1 = 0;
	~networkInputSelector2 = 0;
	~networkSwitchOut0 = 0;
	~networkSyncOut0 = 0;
	~chosenScaleAdjust = [];
	~osc0pitch0Message = 0;
	~pitchMessage0 = 0;
	~pitchMessage1 = 0;
	~tempo0Message0 = 0;
	~tempo1Message0 = 0;
	~interactTempo0 = 0;
	~grainPitch0Message0 = 0;
	~visualFilter0 = 0;
	~visualFilter1 = 0;
	~visualFilter2 = 0;
	~visualSpectrum0 = 0;
	~visualSpectrum1 = 0;
	~visualSpectrum2 = 0;

// Input Synth obtains sound from selected audio input.

	SynthDef(\input,{

	arg input = 0;

	var soundInput0, soundInput1;

	soundInput0 = SoundIn.ar(0);
	soundInput1 = SoundIn.ar(1);

	Out.ar(~soundInputBus0, soundInput0);
	Out.ar(~soundInputBus1, soundInput1);
	}).send(s);

// Buffer synth contains Sample UGens and selector between Sample UGens, Live inputs, and SynthDef Inputs. Obtains Tempo, Pitch and MFCCs of selected input. Completes pitch following task. Modifies pitch, time stretch, grain length etc of respective input
	SynthDef(\buffer,{

	arg  osc0pitch0 = 1, tempoCompare0 = 1, tempoCompare1 = 1, timeStretcher1 = 1, osc0freq0 = 440, osc1freq0 = 440, start0 = 0, end0 = 0, start1 = 0,  end1 = 0, start2 = 0, end2 = 0, osc0Level0 = 0, osc1Level0 = 0, meanUpdate = 20, onsetChooser = 0, reset2 = 0, reset0 = 0, reset1 = 0,	playRate = 1, grainAttack0 = 0.05, mfcc0 = [0,0,0,0,0,0,0,0,0,0,0,0,0], mfcc1 = [0,0,0,0,0,0,0,0,0,0,0,0,0], mfcc2 = [0,0,0,0,0,0,0,0,0,0,0,0,0], position0Array0 = [0,0,0], timeStretcher0 = 1, chooser = 0, beatChooser = 0, beatChooser1 = 0, triggerChooser = 1, onsets2 = [0,0,0,0,0,0,0,0,0,0,0,0,0], osc2Chooser0 = 0, fixedPitch = 220, fixedChooser = 0, timeStretcher2 = 1, meanUpdate1 = 20, meanUpdate2 = 20, meanUpdate3 = 20, attack0 = 0.01, release0 = 0.01, attack1 = 0.01, release1 = 0.01, attack2 = 0.01, release2 = 0.01, attackMultiplier0 = 1, grainPitcher2 = 1, stretcher = 1, resetChooser0 = 0, stretchChooser0 = 0, midiIn0 = 0, midiIn1 = 0, midiIn2 = 0, grainPitcher0  = 1, grainPitcher1 = 1, filterLevel2 = 0, grainLevel0 = 0, grainLevel1 = 0, grainLevel2 = 0, filterLevel0 = 0, filterLevel1 = 0, osc2Level0 = 0, grainLength0 = 0.1, grainLength1 = 0.1, scaleChooser = 0, grainLength2 = 0.1, spliceDuration = 1, networkChooser0 = 0, networkOnsets0 = #[0,0,0,0,0,0,0,0,0,0,0,0,0], networkOnsets1 = #[0,0,0,0,0,0,0,0,0,0,0,0,0], networkOnsets2 = #[0,0,0,0,0,0,0,0,0,0,0,0,0], dryLevel0 = 1, fxLevel0 = 0, grainSpeed0 = 1, grainSpeed1 = 1, loopOn0 = 0, loopOn1 = 0, loopOn2 = 0, networkPitch0 = #[0, 0, 0], filtersOn0 = 0, filtersOn1 = 0, filtersOn2 = 0, filterTrackingOn0 = 0, filterTrackingOn1 = 0, filterTrackingOn2 = 0, pitchTrackOn = 1, adjuster0 = -2000, adjuster1 = -2000, adjuster2 = 0, sampleRate0 = 0, sampleRate1 = 0, sampleRate2 = 0, osc1Chooser0 = 0, synthMicChooser0 = 0, osc0Chooser0 = 0, masterChooser = 0, tempoChooser0 = 0, amplitudeChooser0 = 1, mfccReturn0 = 0, mfccReturn1 = 0, mfccReturn2 = 0, mainOutLevel0 = 1, inputLevel0 = 1, grainInputChooser0 = 0, clipAdjust = 1;

	var osc0, pitcher0, pitchOut0, hasPitchOut0, osc2PitchOut0, filterPitch1, filterPitch4, fftAnalysis0, fftAnalysis2, osc1, osc1Filter0, osc1Filter1, osc1Filter2, osc1Filter3, osc1Filter4, pitcher1, hasPitcher1, fftAnalysis1, breed, materialLength, materialPosition0, materialPosition1, materialPosition2, materialPosition3, osc0Out0, osc1Out0, grain0Out0, grain1Out0, feedbackGrain0Out0, pitcher2, hasPitcher2, osc2, gui0Array0, osc2Out0, ratePitches, pitchTest, osc2Array0, input, buffer, osc0Array0, osc0Sample0, feedback, mat3Trigger, onsetSelector0, onsetSelector1, onsetSelector2, beatTrackSelector1, meanPitcher1, meanPitchOut, osc2Out1, input2BufferWr0, input2osc2, input2Pitch0, inputSelectorPitch, inputSelector, filterMix0, filterMix1, filterMix2, meanTrigger1, meanTrigger2, meanTrigger3, buffer00, attackTrigger, attack0Mean, attack1Mean, attack2Mean, outputSelector, filterOutputMix, osc2Array2, comb, outputDelay, filterHPFOutputMix, input00, inputBus0, inputBus1, synth0, synth0Env0, synth1, synth1Env0, synth2, input1, controlRate0, controlRate1, controlRate2, tempoBuffer0, tempoBuffer1, tempoBuffer2, tempoPosition0, tempoPosition1, tempoPosition2, mfccAnalysis0, mfccAnalysis1, pitchChooser0;

	var onset0Mix0, onset1Mix0, feedback0GrainMix0, outputMix, materialPosition4, materialPosition5, mfccMean0, mfccMean1, mfccMean2, grainOutputChooser, crotchetTick2, quaverTick2, semiquaverTick2, tempo2;

	var crotchetTick0, quaverTick0, semiquaverTick0, tempo0, crotchetTick1, quaverTick1, semiquaverTick1, tempo1, input2osc3, input2Pitch1, tempoMean0, tempoMean1, tempoMean2, beatTrack2;

	var onsets0, onsets1, input0, inputPitch0, inputPitcher0, hasinputPitcher0, pitchTest1, inputSelectorPitch1, osc21, inputSelector1, osc2Array1;

	var envelopes0, envelopes1, envelopes2, mean, meanTrigger, meanInputPitcher0, meanPitcher2;

	var filterOut0, beatTrackSelector, osc0Array1, osc11, delay, reverb, scaleReturn, synthsPower;

	beatTrackSelector = Select.kr(beatChooser, [timeStretcher1, tempoCompare0]);
	beatTrackSelector1 = Select.kr(beatChooser1, [timeStretcher2, tempoCompare1]);

// Collect control bus data and input audio busses
	feedback = In.kr(~gui0Bus0, 63);
	onset0Mix0 = InFeedback.ar(~grain0Bus0, 2);
	onset1Mix0 = InFeedback.ar(~grain1Bus0, 2);
	feedback0GrainMix0 = InFeedback.ar(~grain2Bus0, 2);
	scaleReturn = InFeedback.ar(~scaleBusOut0, 1);
	onsets0 = In.kr(~trigger0Bus0, 13);
	onsets1 = In.kr(~trigger1Bus0, 13);
 	onsets2 = In.kr(~grainGuiTriggerBus0, 13);
 	inputBus0 = InFeedback.ar(~soundInputBus0, 1) * inputLevel0;
 	inputBus1 = InFeedback.ar(~soundInputBus1, 1) * inputLevel0;
 	synth0 = InFeedback.ar(~synthBus0, 1);
 	synth1 = InFeedback.ar(~synthBus1, 1);
	synth2 = InFeedback.ar(~synthBus2, 1);

// Phasors for control source one and two
	materialPosition0 = RedPhasor2.ar(midiIn0, BufRateScale.kr(c.bufnum) * timeStretcher0, start0, end0, loopOn0, start0, end0);
	tempoPosition0 = RedPhasor2.ar(midiIn0, BufRateScale.kr(c.bufnum), start0, end0, loopOn0, start0, end0);
	materialPosition1 = RedPhasor2.ar(midiIn1, BufRateScale.kr(d.bufnum) * beatTrackSelector, start1, end1, loopOn1, start1, end1);
	tempoPosition1 = RedPhasor2.ar(midiIn1, BufRateScale.kr(d.bufnum), start1, end1, loopOn1, start1, end1);
	attackTrigger = Impulse.kr(20);

// Average envelope follower value
	attack0Mean = MeanTriggered.kr(attack0 * attackMultiplier0, attackTrigger, 1);
	attack1Mean = MeanTriggered.kr(attack1 * attackMultiplier0, attackTrigger, 1);
	attack2Mean = MeanTriggered.kr(attack2 * attackMultiplier0, attackTrigger, 1);

// Live input source for control one
	input = (inputBus0 * EnvGen.kr(Env.adsr(attack0Mean, attack0Mean, 1, release0 * attackMultiplier0, 1, 'sine'), midiIn0, 0.1));

// Sample UGens for control one
	buffer = (Warp1.ar(1, c, (materialPosition0/BufFrames.kr(c)), grainPitcher0, grainLength0, -1, 8, 0.1, 2) * EnvGen.kr(Env.adsr(attack0Mean, attack0Mean, 1, release0 * attackMultiplier0, 1, 'sine'), midiIn0, 0.1));
	buffer00 = Warp1.ar(1, c, (materialPosition0/BufFrames.kr(c)), grainPitcher0, grainLength0, -1, 8, 0.1, 2);

// SynthDef input source for control one
	synth0Env0 = (synth0 * EnvGen.kr(Env.adsr(attack0Mean, attack0Mean, 1, release0 * attackMultiplier0, 1, 'sine'), midiIn0, 0.1));
	tempoBuffer0 = Warp1.ar(1, c, (tempoPosition0/BufFrames.kr(c)), 1, grainLength0, -1, 8, 0.1, 2);

// Control one input selector
	osc0Array0 = Select.ar(osc0Chooser0, [buffer, synth0Env0, input]) * osc0Level0;
	osc0Array1 = Select.ar(osc0Chooser0, [buffer00, synth0, inputBus0]);

// Extract control one's pitch
	inputPitch0 = LPF.ar(osc0Array1, 4000);
	# inputPitcher0, hasinputPitcher0 = Pitch.kr(inputPitch0);

// Sample UGens for control two
	osc1 = (Warp1.ar(1, d, (materialPosition1/BufFrames.kr(d)), grainPitcher1, grainLength1, -1, 8, 0.1, 2) * EnvGen.kr(Env.adsr(attack1Mean, attack1Mean, 1, release0 * attackMultiplier0, 1, 'sine'), midiIn1, 0.1)) * osc1Level0;
	osc11 = Warp1.ar(1, d, (materialPosition1/BufFrames.kr(d)), grainPitcher1, grainLength1, -1, 8, 0.1, 2);

// Live input source for control two
	input1 = (inputBus0 * EnvGen.kr(Env.adsr(attack1Mean, attack1Mean, 1, release1 * attackMultiplier0, 1, 'sine'), midiIn1, 0.1)) * osc1Level0;
	tempoBuffer1 = Warp1.ar(1, d, (tempoPosition1/BufFrames.kr(d)), 1, grainLength1, -1, 8, 0.1, 2);

// SynthDef input source for control two
	synth1Env0 = (synth1 * EnvGen.kr(Env.adsr(attack1Mean, attack1Mean, 1, release0 * attackMultiplier0, 1, 'sine'), midiIn1, 0.1)) * osc1Level0;

// Extract control two's pitch
	filterPitch1 = LPF.ar(Select.ar(osc1Chooser0, [osc11, synth1, inputBus0]), 4000);
	# pitcher1, hasPitcher1 = Pitch.kr(filterPitch1);

// Select onset from Control One for trigger of Slave's envelope
 	onsetSelector0 = Select.kr(networkChooser0, [Select.kr(onsetChooser, [onsets0[0], onsets0[1], onsets0[2], onsets0[3], onsets0[4], onsets0[5], onsets0[6], onsets0[7], onsets0[8], onsets0[9], onsets0[10], onsets0[11], onsets0[12]])], [Select.kr(onsetChooser, [networkOnsets0[0], networkOnsets0[1], networkOnsets0[2], networkOnsets0[3], networkOnsets0[4], networkOnsets0[5], networkOnsets0[6], networkOnsets0[7], networkOnsets0[8], networkOnsets0[9], networkOnsets0[10], networkOnsets0[11], networkOnsets0[12]])]);

// Select onset from Control Two for trigger of Slave's envelope
 	onsetSelector1 = Select.kr(networkChooser0, [Select.kr(onsetChooser, [onsets1[0], onsets1[1], onsets1[2], onsets1[3], onsets1[4], onsets1[5], onsets1[6], onsets1[7], onsets1[8], onsets1[9], onsets1[10], onsets1[11], onsets1[12]])], [Select.kr(onsetChooser, [networkOnsets1[0], networkOnsets1[1], networkOnsets1[2], networkOnsets1[3], networkOnsets1[4], networkOnsets1[5], networkOnsets1[6], networkOnsets1[7], networkOnsets1[8], networkOnsets1[9], networkOnsets1[10], networkOnsets1[11], networkOnsets1[12]])]);

// Select onset from Control Three for trigger of Slave's envelope
 	onsetSelector2 = Select.kr(networkChooser0, [Select.kr(onsetChooser, [onsets2[0], onsets2[1], onsets2[2], onsets2[3], onsets2[4], onsets2[5], onsets2[6], onsets2[7], onsets2[8], onsets2[9], onsets2[10], onsets2[11], onsets2[12]])], [Select.kr(onsetChooser, [networkOnsets2[0], networkOnsets2[1], networkOnsets2[2], networkOnsets2[3], networkOnsets2[4], networkOnsets2[5], networkOnsets2[6], networkOnsets2[7], networkOnsets2[8], networkOnsets2[9], networkOnsets2[10], networkOnsets2[11], networkOnsets2[12]])]);

//Select trigger source for Slave
  	mat3Trigger = Select.kr(triggerChooser, [midiIn2.round(1), onsetSelector0.round(1), onsetSelector1.round(1), onsetSelector2.round(1)]);

// Phasor for Sample UGens of Slave
   materialPosition2 = RedPhasor2.ar(mat3Trigger, BufRateScale.kr(b.bufnum) * (beatTrackSelector1 * Select.kr(stretchChooser0, [1, stretcher])), Select.kr(resetChooser0, [start2, reset2]), end2, loopOn2, Select.kr(resetChooser0, [start2, reset2]), end2);

// Phasor for Live Input UGens os Slave
   materialPosition4 = Phasor.ar(Impulse.kr(s.sampleRate), BufRateScale.kr(~inputBuffer.bufnum), 0, ~inputBuffer.numFrames);

// Phasor to adjust tempo of Slave
   tempoPosition2 = RedPhasor2.ar(mat3Trigger, BufRateScale.kr(b.bufnum), Select.kr(resetChooser0, [start2, reset2]), end2, loopOn2, Select.kr(resetChooser0, [start2, reset2]), end2);

// Write live input or synthdef input for Slave to buffer
	input2BufferWr0 = BufWr.ar(Select.ar(synthMicChooser0, [synth2 * 0.75, Select.ar(grainInputChooser0, [inputBus0, inputBus0]) * 0.75]), ~inputBuffer,  Phasor.ar(0, BufRateScale.kr(~inputBuffer.bufnum), 0, BufFrames.kr(~inputBuffer)));

// Sample UGens for Slave
	pitchTest = (Warp1.ar(1, b, (materialPosition2/BufFrames.kr(b)), grainPitcher2, grainLength2, -1, 8, 0.1, 2) * EnvGen.kr(Env.adsr(attack2Mean, attack2Mean, Select.kr(resetChooser0, [1, spliceDuration.max(0.5)]), release2 * attackMultiplier0, 1, 'sine'), mat3Trigger + Select.kr(amplitudeChooser0, [0, mfccReturn0, mfccReturn1, mfccReturn2]), 0.1));
	pitchTest1 = Warp1.ar(1, b, (materialPosition2/BufFrames.kr(b)), grainPitcher2, grainLength2, -1, 8, 0.1, 2);

// Playback buffered recording of live/synthdef input
	input2Pitch0 = (Warp1.ar(1, ~inputBuffer, (materialPosition4/BufFrames.kr(~inputBuffer)) * (beatTrackSelector1 * Select.kr(stretchChooser0, [1, stretcher])), 1, grainLength2, -1, 8, 0.1, 2) * EnvGen.kr(Env.adsr(attack2Mean, attack2Mean, Select.kr(resetChooser0, [1, spliceDuration.max(0.5)]), release2 * attackMultiplier0, 1, 'sine'), mat3Trigger + Select.kr(amplitudeChooser0, [0, mfccReturn0, mfccReturn1, mfccReturn2]), 0.1));
	input2Pitch1 = Warp1.ar(1, ~inputBuffer, (materialPosition4/BufFrames.kr(~inputBuffer)) * (beatTrackSelector1 * Select.kr(stretchChooser0, [1, stretcher])), 1, grainLength2, -1, 8, 0.1, 2);
	tempoBuffer2 = Warp1.ar(1, b, (tempoPosition2/BufFrames.kr(b)), 1, grainLength2, -1, 8, 0.1, 2);

// Pitch shift selected source through GUI
	inputSelectorPitch = Select.ar(osc2Chooser0, [pitchTest, PitchShift.ar(input2Pitch0, 0.2, grainPitcher2)]);
	inputSelectorPitch1 = Select.ar(osc2Chooser0, [pitchTest1, PitchShift.ar(input2Pitch1, 0.2, grainPitcher2)]);

	osc2 = (Warp1.ar(1, b, (materialPosition2/BufFrames.kr(b)), 1, grainLength2, -1, 8, 0.1, 2) * EnvGen.kr(Env.adsr(attack2Mean, attack2Mean, Select.kr(resetChooser0, [1, spliceDuration.max(0.5)]), release2 * attackMultiplier0, 1, 'sine'), mat3Trigger + Select.kr(amplitudeChooser0, [0, mfccReturn0, mfccReturn1, mfccReturn2]), 0.1));
	osc21 = Warp1.ar(1, b, (materialPosition2/BufFrames.kr(b)), 1, grainLength2, -1, 8, 0.1, 2);

// Extract pitch of Slave
	filterPitch4 = LPF.ar(osc21, 4000);

	# pitcher2, hasPitcher2 = Pitch.kr(filterPitch4);

// Pitch Following selector
	osc2Array0 = inputSelectorPitch * osc2Level0;
	osc2Array1 = inputSelectorPitch1;
	osc2Array2 = inputSelectorPitch;

// Extract pitch of pitch followed Slave
	# pitchOut0, hasPitchOut0 = Pitch.kr(osc2Array2);

// Buffer position of Phasors
	position0Array0 = [materialPosition0, materialPosition1, materialPosition2];

// Extract MFCCs and tempo of Control one
	fftAnalysis0 = FFT(~fftBuffer0, Select.ar(osc0Chooser0, [tempoBuffer0, synth0, inputBus0]));
	#crotchetTick0, quaverTick0, semiquaverTick0, tempo0 = BeatTrack.kr(fftAnalysis0, 0);

	mfccAnalysis0 = FFT(~mfccBuffer0, osc0Array1);
	mfcc0 = MFCC.kr(mfccAnalysis0);

// Extract MFCCs and tempo of Control two
	fftAnalysis1 = FFT(~fftBuffer1, Select.ar(osc1Chooser0, [tempoBuffer1, synth1, inputBus0]));
	#crotchetTick1, quaverTick1, semiquaverTick1, tempo1 = BeatTrack.kr(fftAnalysis1, 0);

	mfccAnalysis1 = FFT(~mfccBuffer1, Select.ar(osc1Chooser0, [osc11, synth1, inputBus0]));
	mfcc1 = MFCC.kr(mfccAnalysis1);

// Extract MFCCs and tempo of Slave
	beatTrack2 = FFT(~fftBuffer2, Select.ar(tempoChooser0, [tempoBuffer2, synth2, Select.ar(grainInputChooser0, [inputBus0, inputBus0])]));
	#crotchetTick2, quaverTick2, semiquaverTick2, tempo2 = BeatTrack.kr(beatTrack2, 0);

	fftAnalysis2 = FFT(~mfccBuffer2, osc2Array1);
	mfcc2 = MFCC.kr(fftAnalysis2);

// average selected values
	meanTrigger = Impulse.kr(meanUpdate1);

	meanInputPitcher0 = MeanTriggered.kr(inputPitcher0, meanTrigger, 1);

	meanPitcher1 = MeanTriggered.kr(pitcher1, meanTrigger, 1);

	meanPitcher2 = MeanTriggered.kr(Select.kr(fixedChooser, [pitcher2, fixedPitch]), meanTrigger, 1);

	meanPitchOut = MeanTriggered.kr(pitchOut0, meanTrigger, 1);

// Pitch following algorithm
	ratePitches = Select.kr(fixedChooser, [Select.kr(networkChooser0, [meanInputPitcher0/meanPitcher2, networkPitch0[0]/meanPitcher2]), Select.kr(networkChooser0, [meanInputPitcher0/meanPitcher2, networkPitch0[0]/meanPitcher2])]);

// average selected values
	mean = MeanTriggered.kr(ratePitches, meanTrigger, 1);

	meanTrigger1 = Impulse.kr(meanUpdate1);
	meanTrigger2 = Impulse.kr(meanUpdate2);
	meanTrigger3 = Impulse.kr(meanUpdate3);

	mfccMean0 = MeanTriggered.kr(mfcc0, meanTrigger1, 1);
	mfccMean1 = MeanTriggered.kr(mfcc1, meanTrigger2, 1);
	mfccMean2 = MeanTriggered.kr(mfcc2, meanTrigger3, 1);

	controlRate0 = tempo0/tempo1;
	controlRate1 = tempo0/tempo2;
	controlRate2 = tempo1/tempo2;

	tempoMean0 = MeanTriggered.kr(controlRate0, meanTrigger, 1);
	tempoMean1 = MeanTriggered.kr(controlRate1, meanTrigger, 1);
	tempoMean2 = MeanTriggered.kr(controlRate2, meanTrigger, 1);

	synthsPower = Amplitude.kr(LPF.ar(feedback0GrainMix0 + onset0Mix0 + onset1Mix0, 4000));

// Mix auditory output

	outputMix = Mix.new([feedback0GrainMix0 + onset0Mix0 + onset1Mix0 + osc0Array0 + Select.ar(osc1Chooser0, [osc1, synth1Env0, input1]) + Select.ar(scaleChooser, [osc2Array0, (scaleReturn * osc2Level0)])]);

// Send audio to selected busses
	Out.ar(~fxBus0, (Pan2.ar(outputMix, 0, 1)));
	Out.ar(~tempo0Bus0, (Pan2.ar(osc0Array0, 0, 1)));
	Out.ar(~osc0Bus0, (Pan2.ar(osc0Array1, 0, 1)));
	Out.ar(~osc1Bus0, (Pan2.ar(Select.ar(osc1Chooser0, [osc11, synth1, inputBus0]), 0, 1)));
	Out.ar(~osc2Bus0, (Pan2.ar(Select.ar(scaleChooser, [osc2Array2, scaleReturn]) , 0, clipAdjust)));
	Out.ar(~scaleSend0, (osc2Array2));
	Out.ar(~bufferBus0, Select.ar(osc0Chooser0, [buffer00, synth0, inputBus0]));
	Out.ar(~bufferBus1, Select.ar(osc1Chooser0, [osc11, synth1, inputBus0]));
	Out.ar(~bufferBus2, osc2Array1);
	Out.kr(~mfccBus0, mfccMean0);
	Out.kr(~mfccBus1, mfccMean1);
	Out.kr(~mfccBus2, mfccMean2);
	Out.kr(~position0Bus0, position0Array0);
	Out.kr(~controlTempoBus0, [tempoMean0, Select.kr(masterChooser, [tempoMean1, tempoMean2]), tempo2]);

// Send control data to selected bus
	gui0Array0 = [attackMultiplier0, meanUpdate, osc0pitch0, osc0freq0, Select.kr(networkChooser0, [meanInputPitcher0, networkPitch0[0]]), meanInputPitcher0, meanPitcher1, timeStretcher1, osc1freq0, filtersOn0, filtersOn1, playRate, tempo0, tempo1, tempo2, attack0Mean, attack1Mean, attack2Mean, Select.kr(networkChooser0, [grainPitcher0, networkPitch0[1]]), grainPitcher1, timeStretcher0, timeStretcher2, grainPitcher2, filtersOn2, meanPitchOut, mean, pitcher2, dryLevel0, osc0Level0, osc1Level0, osc2Level0, grainLevel0, grainLevel1, grainLevel2, filterLevel0, filterLevel1, filterLevel2, meanUpdate1, meanUpdate2, meanUpdate3, grainLength0, grainLength1, grainLength2, grainSpeed0, grainSpeed1, fxLevel0, filterTrackingOn0, filterTrackingOn1, filterTrackingOn2, fixedChooser, pitchTrackOn, adjuster0, adjuster1, adjuster2, sampleRate0, sampleRate1, sampleRate2,0.5 ,0.5, 0.5, networkChooser0, mainOutLevel0, synthsPower.max(0)];

	Out.kr(~gui0Bus0, gui0Array0);
	}).send(s);

// Amplitude Synth extract Loudness of inputs for envelope following process

	SynthDef(\amplitude, {

	arg out = 0;

	var buffer0, buffer1, buffer2, power0, power1, power2, fft0, fft1, fft2;

// Collect selected input from Audio busses
	buffer0 = InFeedback.ar(~bufferBus0, 1);
	buffer1 = InFeedback.ar(~bufferBus1, 1);
	buffer2 = InFeedback.ar(~bufferBus2, 1);

// Extract Loudness
	fft0 = FFT(~powerBuffer0, buffer0);
	power0 = Loudness.kr(fft0);
	fft1 = FFT(~powerBuffer1, buffer1);
	power1 = Loudness.kr(fft1);
	fft2 = FFT(~powerBuffer2, buffer2);
	power2 = Loudness.kr(fft2);

// Send Loudness values to control bus
	Out.kr(~powersBus0, [power0.max(0.01), power1.max(0.01), power2.max(0.01)]);

	}).send(s);

// FX Synth places reverb, pan, and filter from random search process on to main auditory output

	SynthDef(\fx, {

	arg grainChooser = 0, grainSize0 = 0.05, grainSpeed0 = 10, grainSize1 = 0.05, grainSpeed1 = 10, grainPan0 = -1, grainPan1 = 1, grainVol0 = 1, grainVol1 = 1, combChooser = 0, mix1 = 0.5, damper1 = 0.5, hpfFreq = 400, hpfRes = 1, roomSize0 = 5, damper = 0.5, reverbChooser = 0, lpfFreq = 440, lpfRes = 0.01, filterDecay = 0.01, outputChooser = 0, revTime = 1, spread = 15, earlyRf = 0.7, tailLev = 0.5, recordOn = 0, recLevel = 1.8, interactBufferOn0 = 0;

	var outputMix, filterHPFOutputMix, filterOutputMix, outputSelector, delay, reverb, outputDelay, grainOutput0, grainOutput1, grainOutputChooser, levels0 = [], recordBuf0, recordOutputChooser, recordOutputMix, interactBuf0;

// obtain dry output
	outputMix = InFeedback.ar(~fxBus0, 2);
	recordOutputMix = InFeedback.ar(~fxBus0, 2);

	levels0 = In.kr(~gui0Bus0, 63);

// filter output
	filterHPFOutputMix = RHPF.ar(outputMix, hpfFreq, hpfRes) * 0.2;
	filterOutputMix = RLPF.ar(filterHPFOutputMix, lpfFreq, lpfRes);

	outputSelector = Select.ar(outputChooser, [outputMix, filterOutputMix]);

// add reverb to output
	reverb = GVerb.ar(outputSelector, roomSize0, revTime, damper, damper, spread, 0, earlyRf, tailLev, 300);

// pan output
	grainOutput0 = MonoGrain.ar(reverb, grainSize0, grainSpeed0, 0);
	grainOutput1 = MonoGrain.ar(reverb, grainSize1, grainSpeed1, 0);

// select fx relative to GUI settings
	grainOutputChooser = Select.ar(grainChooser, [reverb, Mix.new([(Pan2.ar(grainOutput0, grainPan0, grainVol0)) + (Pan2.ar(grainOutput1, grainPan1, grainVol1))])]);

	recordOutputChooser = Select.ar(grainChooser, [reverb, Mix.new([(Pan2.ar(grainOutput0, grainPan0, grainVol0)) + (Pan2.ar(grainOutput1, grainPan1, grainVol1))])]);

// send output to audio bus out
	Out.ar(0, (Pan2.ar(Mix.new([(grainOutputChooser * levels0[45]/6) + (outputMix * levels0[27]/6)]), 0, levels0[61])));

// record output for live sampling process
	recordBuf0 = RecordBuf.ar(Pan2.ar(Limiter.ar(Mix.new([(recordOutputChooser * levels0[45]) + (recordOutputMix * levels0[27])]), 1, 0.05), 0, 1), ~recordBuffer0, 0, recLevel, 0, recordOn, 0, recordOn);

// record output for Call and Response process
	interactBuf0 = RecordBuf.ar(Pan2.ar(Limiter.ar(Mix.new([(recordOutputChooser * levels0[45]) + (recordOutputMix * levels0[27])]), 1, 0.05), 0, 1), ~interactBuffer0, 0, interactBufferOn0, 0, interactBufferOn0, 0, interactBufferOn0);

	}).send(s);

// Interact  Synth forms Call and Response process UGens

	SynthDef(\interact, {

	arg triggerOn0 = 0, volumeOut0 = 1, timeStretcher0 = 1, start0 = 0, end0 = ~interactBuffer0.numFrames, loopOn0 = 1, pitch0 = 1, attackTime0 = 0.5, releaseTime0 = 0.5, sustainTime0 = 1, amplitude0 = 0;

	var output, materialPosition0;

// Phasor for Response
	materialPosition0 = RedPhasor2.ar(triggerOn0, BufRateScale.kr(~interactBuffer0.bufnum) * timeStretcher0, start0, end0, loopOn0, start0, end0);

// Warp UGen for Response
	output = Warp1.ar(2, ~interactBuffer0, materialPosition0/BufFrames.kr(~interactBuffer0), pitch0, 0.15, -1, 8, 0.1, 4) * EnvGen.kr(Env.linen(attackTime0, sustainTime0, releaseTime0, amplitude0, -4), triggerOn0, 1);

// send output to audio bus out
	Out.ar(0, (Pan2.ar(Limiter.ar(Mix.new([output]), 1, 0.05), 0, volumeOut0)));

	}).send(s);

//Granular Synths triggered by onsets of Control One
	SynthDef(\macroGranulator0,{
	arg  onset0Duration0 = 1, onset0Duration1 = 1, onset0Duration2 = 1, onset0Duration3 = 1, onset0Duration4 = 1, onset0Duration5 = 1, onset0Duration6 = 1, onset0Duration7 = 1, onset0Duration8 = 1, onset0Duration9 = 1, onset0Duration10 = 1, onset0Duration11 = 1, onset0Duration12 = 1, networkOnsets0 = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	grain0Pitch0 = 1, grain0Pitch1 = 1, grain0Pitch2 = 1, grain0Pitch3 = 1, grain0Pitch4 = 1, grain0Pitch5 = 1, grain0Pitch6 = 1, grain0Pitch7 = 1, grain0Pitch8 = 1, grain0Pitch9 = 1, grain0Pitch10 = 1, grain0Pitch11 = 1, grain0Pitch12 = 1,

	grain1Pitch0 = 1, grain1Pitch1 = 1, grain1Pitch2 = 1, grain1Pitch3 = 1, grain1Pitch4 = 1, grain1Pitch5 = 1, grain1Pitch6 = 1, grain1Pitch7 = 1, grain1Pitch8 = 1, grain1Pitch9 = 1, grain1Pitch10 = 1, grain1Pitch11 = 1, grain1Pitch12 = 1, envelopeType = -1,

	grain0Attack0 = 0.1, grain0Attack1 = 0.1, grain0Attack2 = 0.1, grain0Attack3 = 0.1, grain0Attack4 = 0.1, grain0Attack5 = 0.1, grain0Attack6 = 0.1, grain0Attack7 = 0.1, grain0Attack8 = 0.1, grain0Attack9 = 0.1, grain0Attack10 = 0.1, grain0Attack11 = 0.1, grain0Attack12 = 0.1,

	grain0Release0 = 0.1,  grain0Release1 = 0.1, grain0Release2 = 0.1, grain0Release3 = 0.1, grain0Release4 = 0.1, grain0Release5 = 0.1, grain0Release6 = 0.1, grain0Release7 = 0.1, grain0Release8 = 0.1, grain0Release9 = 0.1, grain0Release10 = 0.1, grain0Release11 = 0.1, grain0Release12 = 0.1,

	fractal0Grain0 = 0, fractal0Grain1 = 0, fractal0Grain2 = 0, fractal0Grain3 = 0, fractal0Grain4 = 0, fractal0Grain5 = 0, fractal0Grain6 = 0, fractal0Grain7 = 0, fractal0Grain8 = 0, fractal0Grain9 = 0, fractal0Grain10 = 0, fractal0Grain11 = 0, fractal0Grain12 = 0,

	interpolation = 4, bitRate0 = 16,

	osc0Freq0 = 400, osc0Freq1 = 400, osc0Freq2 = 400, osc0Freq3 = 400, osc0Freq4 = 400, osc0Freq5 = 400, osc0Freq6 = 400, osc0Freq7 = 400, osc0Freq8 = 400, osc0Freq9 = 400, osc0Freq10 = 400, osc0Freq11 = 400, osc0Freq12 = 400,

	amplitude0 = 0, amplitude1 = 0, amplitude2 = 0, amplitude3 = 0, amplitude4 = 0, amplitude5 = 0, amplitude6 = 0, amplitude7 = 0, amplitude8 = 0, amplitude9 = 0, amplitude10 = 0, amplitude11 = 0, amplitude12 = 0,

	networkFilters0 = #[0,0,0,0,0,0,0,0,0,0,0,0,0], pitchTrackOn = 0;

	var onsets0, onsets1, onsets2, envelopes0, envelopes1, envelopes2, positionArray0, filterData0, pitchTracker;

	var onsetDuration0Array0, onsetDuration1Array0, networkChooser0, feedback0, grain0PitchArray0, grain1PitchArray0, grain2PitchArray0;

	var osc0Decimate0, osc0Decimate1, osc0Decimate2, osc0Decimate3, osc0Decimate4, osc0Decimate5, osc0Decimate6, osc0Decimate7, osc0Decimate8, osc0Decimate9, osc0Decimate10, osc0Decimate11, osc0Decimate12;

	var osc0Limiter0, osc0Limiter1, osc0Limiter2, osc0Limiter3, osc0Limiter4, osc0Limiter5, osc0Limiter6, osc0Limiter7, osc0Limiter8, osc0Limiter9, osc0Limiter10, osc0Limiter11, osc0Limiter12;

	var pitchChooser0, pitchChooser1, pitchChooser2, pitchChooser3, pitchChooser4, pitchChooser5, pitchChooser6, pitchChooser7, pitchChooser8, pitchChooser9, pitchChooser10, pitchChooser11, pitchChooser12;

	var position0, position1, position2, position3, position4, position5, position6, position7, position8, position9, position10, position11, position12;

	var positionEnd0, positionEnd1, positionEnd2, positionEnd3, positionEnd4, positionEnd5, positionEnd6, positionEnd7, positionEnd8, positionEnd9, positionEnd10, positionEnd11, positionEnd12;

	var duration0, duration1, duration2, duration3, duration4, duration5, duration6, duration7, duration8, duration9, duration10, duration11, duration12;

	var onset0GrainMacro0, onset0GrainMacro1, onset0GrainMacro2, onset0GrainMacro3, onset0GrainMacro4, onset0GrainMacro5, onset0GrainMacro6, onset0GrainMacro7, onset0GrainMacro8, onset0GrainMacro9, onset0GrainMacro10, onset0GrainMacro11, onset0GrainMacro12;

	var osc0Filter0, osc0Filter1, osc0Filter2, osc0Filter3, osc0Filter4, osc0Filter5, osc0Filter6, osc0Filter7, osc0Filter8, osc0Filter9, osc0Filter10, osc0Filter11, osc0Filter12;

	onsetDuration0Array0 = [onset0Duration0, onset0Duration1, onset0Duration2, onset0Duration3, onset0Duration4, onset0Duration5, onset0Duration6, onset0Duration7, onset0Duration8, onset0Duration9,onset0Duration10, onset0Duration11, onset0Duration12];

// Collect onsets for control one from control bus
	onsets0 = In.kr(~onset0Bus0, 13);

// Collect envelope for control one from control bus
	envelopes0 = In.kr(~envelopeBus0, 13);

// Collect spectral tracking for control one from control bus
	filterData0 = In.kr(~filterTracker0, 13) / 3;

	feedback0 = In.kr(~gui0Bus0, 63);

	pitchTracker = feedback0[25];

	networkChooser0 = feedback0[60];

// Fractal process for playback rate of each granular synthesizer
	pitchChooser0 = Gate.kr(Select.kr(fractal0Grain0, [grain0Pitch0, grain0Pitch0 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets0[0], networkOnsets0[0]]));
	pitchChooser1 = Gate.kr(Select.kr(fractal0Grain1, [grain0Pitch1, grain0Pitch1 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets0[1], networkOnsets0[1]]));
	pitchChooser2 = Gate.kr(Select.kr(fractal0Grain2, [grain0Pitch2, grain0Pitch2 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets0[2], networkOnsets0[2]]));
	pitchChooser3 = Gate.kr(Select.kr(fractal0Grain3, [grain0Pitch3, grain0Pitch3 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets0[3], networkOnsets0[3]]));
	pitchChooser4 = Gate.kr(Select.kr(fractal0Grain4, [grain0Pitch4, grain0Pitch4 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets0[4], networkOnsets0[4]]));
	pitchChooser5 = Gate.kr(Select.kr(fractal0Grain5, [grain0Pitch5, grain0Pitch5 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets0[5], networkOnsets0[5]]));
	pitchChooser6 = Gate.kr(Select.kr(fractal0Grain6, [grain0Pitch6, grain0Pitch6 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets0[6], networkOnsets0[6]]));
	pitchChooser7 = Gate.kr(Select.kr(fractal0Grain7, [grain0Pitch7, grain0Pitch7 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets0[7], networkOnsets0[7]]));
	pitchChooser8 = Gate.kr(Select.kr(fractal0Grain8, [grain0Pitch8, grain0Pitch8 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets0[8], networkOnsets0[8]]));
	pitchChooser9 = Gate.kr(Select.kr(fractal0Grain9, [grain0Pitch9, grain0Pitch9 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets0[9], networkOnsets0[9]]));
	pitchChooser10 = Gate.kr(Select.kr(fractal0Grain10, [grain0Pitch10, grain0Pitch10 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets0[10], networkOnsets0[10]]));
	pitchChooser11 = Gate.kr(Select.kr(fractal0Grain11, [grain0Pitch11, grain0Pitch11 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets0[11], networkOnsets0[11]]));
	pitchChooser12 = Gate.kr(Select.kr(fractal0Grain12, [grain0Pitch12, grain0Pitch12 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets0[12], networkOnsets0[12]]));

// Duration divided by result of fractal process for playback rate of each granular synthesizer
	duration0 = (onset0Duration0/(pitchChooser0 * 2)).abs.min(2);
	duration1 = (onset0Duration1/(pitchChooser1 * 2)).abs.min(2);
	duration2 = (onset0Duration2/(pitchChooser2 * 2)).abs.min(2);
	duration3 = (onset0Duration3/(pitchChooser3 * 2)).abs.min(2);
	duration4 = (onset0Duration4/(pitchChooser4 * 2)).abs.min(2);
	duration5 = (onset0Duration5/(pitchChooser5 * 2)).abs.min(2);
	duration6 = (onset0Duration6/(pitchChooser6 * 2)).abs.min(2);
	duration7 = (onset0Duration7/(pitchChooser7 * 2)).abs.min(2);
	duration8 = (onset0Duration8/(pitchChooser8 * 2)).abs.min(2);
	duration9 = (onset0Duration9/(pitchChooser9 * 2)).abs.min(2);
	duration10 = (onset0Duration10/(pitchChooser10 * 2)).abs.min(2);
	duration11 = (onset0Duration11/(pitchChooser11 * 2)).abs.min(2);
	duration12 = (onset0Duration12/(pitchChooser12 * 2)).abs.min(2);

// Fractal process for buffer position of each granular synthesizer
	position0 = Gate.kr(PinkNoise.kr(~warpBuffer0[0].numFrames), envelopes0[0]);
	position1 = Gate.kr(PinkNoise.kr(~warpBuffer0[1].numFrames), envelopes0[1]);
	position2 = Gate.kr(PinkNoise.kr(~warpBuffer0[2].numFrames), envelopes0[2]);
	position3 = Gate.kr(PinkNoise.kr(~warpBuffer0[3].numFrames), envelopes0[3]);
	position4 = Gate.kr(PinkNoise.kr(~warpBuffer0[4].numFrames), envelopes0[4]);
	position5 = Gate.kr(PinkNoise.kr(~warpBuffer0[5].numFrames), envelopes0[5]);
	position6 = Gate.kr(PinkNoise.kr(~warpBuffer0[6].numFrames), envelopes0[6]);
	position7 = Gate.kr(PinkNoise.kr(~warpBuffer0[7].numFrames), envelopes0[7]);
	position8 = Gate.kr(PinkNoise.kr(~warpBuffer0[8].numFrames), envelopes0[8]);
	position9 = Gate.kr(PinkNoise.kr(~warpBuffer0[9].numFrames), envelopes0[9]);
	position10 = Gate.kr(PinkNoise.kr(~warpBuffer0[10].numFrames), envelopes0[10]);
	position11 = Gate.kr(PinkNoise.kr(~warpBuffer0[11].numFrames), envelopes0[11]);
	position12 = Gate.kr(PinkNoise.kr(~warpBuffer0[12].numFrames), envelopes0[12]);

	positionEnd0 = Gate.kr(PinkNoise.kr(~warpBuffer0[0].numFrames), envelopes0[0]);
	positionEnd1 = Gate.kr(PinkNoise.kr(~warpBuffer0[1].numFrames), envelopes0[1]);
	positionEnd2 = Gate.kr(PinkNoise.kr(~warpBuffer0[2].numFrames), envelopes0[2]);
	positionEnd3 = Gate.kr(PinkNoise.kr(~warpBuffer0[3].numFrames), envelopes0[3]);
	positionEnd4 = Gate.kr(PinkNoise.kr(~warpBuffer0[4].numFrames), envelopes0[4]);
	positionEnd5 = Gate.kr(PinkNoise.kr(~warpBuffer0[5].numFrames), envelopes0[5]);
	positionEnd6 = Gate.kr(PinkNoise.kr(~warpBuffer0[6].numFrames), envelopes0[6]);
	positionEnd7 = Gate.kr(PinkNoise.kr(~warpBuffer0[7].numFrames), envelopes0[7]);
	positionEnd8 = Gate.kr(PinkNoise.kr(~warpBuffer0[8].numFrames), envelopes0[8]);
	positionEnd9 = Gate.kr(PinkNoise.kr(~warpBuffer0[9].numFrames), envelopes0[9]);
	positionEnd10 = Gate.kr(PinkNoise.kr(~warpBuffer0[10].numFrames), envelopes0[10]);
	positionEnd11 = Gate.kr(PinkNoise.kr(~warpBuffer0[11].numFrames), envelopes0[11]);
	positionEnd12 = Gate.kr(PinkNoise.kr(~warpBuffer0[12].numFrames), envelopes0[12]);


// Granular synthesizer UGens controlled by envelopes

	onset0GrainMacro0 = Warp1.ar(1, ~warpBuffer0[0].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets0[0], networkOnsets0[0]]), BufRateScale.kr(~warpBuffer0[0].bufnum), position0, ~warpBuffer0[0].numFrames, 0, position0, ~warpBuffer0[0].numFrames)/~warpBuffer0[0].numFrames) * filterData0[0], pitchChooser0, 0.2, -1, 8) * envelopes0[0];
	onset0GrainMacro1 = Warp1.ar(1, ~warpBuffer0[1].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets0[1], networkOnsets0[1]]), BufRateScale.kr(~warpBuffer0[1].bufnum), position1, ~warpBuffer0[0].numFrames, 0, position1, ~warpBuffer0[1].numFrames)/~warpBuffer0[1].numFrames) * filterData0[1], pitchChooser1, 0.2, -1, 8) * envelopes0[1];
	onset0GrainMacro2 = Warp1.ar(1, ~warpBuffer0[2].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets0[2], networkOnsets0[2]]), BufRateScale.kr(~warpBuffer0[2].bufnum), position2, ~warpBuffer0[0].numFrames, 0, position2, ~warpBuffer0[2].numFrames)/~warpBuffer0[2].numFrames) * filterData0[2], pitchChooser2, 0.2, -1, 8) * envelopes0[2];
	onset0GrainMacro3 = Warp1.ar(1, ~warpBuffer0[3].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets0[3], networkOnsets0[3]]), BufRateScale.kr(~warpBuffer0[3].bufnum), position3, ~warpBuffer0[0].numFrames, 0, position3, ~warpBuffer0[3].numFrames)/~warpBuffer0[3].numFrames) * filterData0[3], pitchChooser3, 0.2, -1, 8) * envelopes0[3];
	onset0GrainMacro4 = Warp1.ar(1, ~warpBuffer0[4].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets0[4], networkOnsets0[4]]), BufRateScale.kr(~warpBuffer0[4].bufnum), position4, ~warpBuffer0[0].numFrames, 0, position4, ~warpBuffer0[4].numFrames)/~warpBuffer0[4].numFrames) * filterData0[4], pitchChooser4, 0.2, -1, 8) * envelopes0[4];
	onset0GrainMacro5 = Warp1.ar(1, ~warpBuffer0[5].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets0[5], networkOnsets0[5]]), BufRateScale.kr(~warpBuffer0[5].bufnum), position5, ~warpBuffer0[0].numFrames, 0, position5, ~warpBuffer0[5].numFrames)/~warpBuffer0[5].numFrames) * filterData0[5], pitchChooser5, 0.2, -1, 8) * envelopes0[5];
	onset0GrainMacro6 = Warp1.ar(1, ~warpBuffer0[6].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets0[6], networkOnsets0[6]]), BufRateScale.kr(~warpBuffer0[6].bufnum), position6, ~warpBuffer0[0].numFrames, 0, position6, ~warpBuffer0[6].numFrames)/~warpBuffer0[6].numFrames) * filterData0[6], pitchChooser6, 0.2, -1, 8) * envelopes0[6];
	onset0GrainMacro7 = Warp1.ar(1, ~warpBuffer0[7].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets0[7], networkOnsets0[7]]), BufRateScale.kr(~warpBuffer0[7].bufnum), position7, ~warpBuffer0[0].numFrames, 0, position7, ~warpBuffer0[7].numFrames)/~warpBuffer0[7].numFrames) * filterData0[7], pitchChooser7, 0.2, -1, 8) * envelopes0[7];
	onset0GrainMacro8 = Warp1.ar(1, ~warpBuffer0[8].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets0[8], networkOnsets0[8]]), BufRateScale.kr(~warpBuffer0[8].bufnum), position8, ~warpBuffer0[0].numFrames, 0, position8, ~warpBuffer0[8].numFrames)/~warpBuffer0[8].numFrames) * filterData0[8], pitchChooser8, 0.2, -1, 8) * envelopes0[8];
	onset0GrainMacro9 = Warp1.ar(1, ~warpBuffer0[9].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets0[9], networkOnsets0[9]]), BufRateScale.kr(~warpBuffer0[9].bufnum), position9, ~warpBuffer0[0].numFrames, 0, position9, ~warpBuffer0[9].numFrames)/~warpBuffer0[9].numFrames) * filterData0[9], pitchChooser9, 0.2, -1, 8) * envelopes0[9];
	onset0GrainMacro10 = Warp1.ar(1, ~warpBuffer0[10].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets0[10], networkOnsets0[10]]), BufRateScale.kr(~warpBuffer0[10].bufnum), position10, ~warpBuffer0[0].numFrames, 0, position10, ~warpBuffer0[10].numFrames)/~warpBuffer0[10].numFrames) * filterData0[10], pitchChooser10, 0.2, -1, 8) * envelopes0[10];
	onset0GrainMacro11 = Warp1.ar(1, ~warpBuffer0[11].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets0[11], networkOnsets0[11]]), BufRateScale.kr(~warpBuffer0[11].bufnum), position11, ~warpBuffer0[0].numFrames, 0, position11, ~warpBuffer0[11].numFrames)/~warpBuffer0[11].numFrames) * filterData0[11], pitchChooser12, 0.2, -1, 8) * envelopes0[11];
	onset0GrainMacro12 = Warp1.ar(1, ~warpBuffer0[12].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets0[12], networkOnsets0[12]]), BufRateScale.kr(~warpBuffer0[12].bufnum), position12, ~warpBuffer0[0].numFrames, 0, position12, ~warpBuffer0[12].numFrames)/~warpBuffer0[12].numFrames) * filterData0[12], pitchChooser12, 0.2, -1, 8) * envelopes0[12];

// Filter each granular synthesizer	controlled by GUI or Spectral Following Process
	osc0Filter0 = BBandPass.ar(onset0GrainMacro0, Select.kr(feedback0[46], [osc0Freq0, Select.kr(feedback0[60], [filterData0[0], networkFilters0[0]])]), feedback0[57]);
	osc0Filter1 = BBandPass.ar(onset0GrainMacro1, Select.kr(feedback0[46], [osc0Freq1, Select.kr(feedback0[60], [filterData0[1], networkFilters0[1]])]), feedback0[57]);
	osc0Filter2 = BBandPass.ar(onset0GrainMacro2, Select.kr(feedback0[46], [osc0Freq2, Select.kr(feedback0[60], [filterData0[2], networkFilters0[2]])]), feedback0[57]);
	osc0Filter3 = BBandPass.ar(onset0GrainMacro3, Select.kr(feedback0[46], [osc0Freq3, Select.kr(feedback0[60], [filterData0[3], networkFilters0[3]])]), feedback0[57]);
	osc0Filter4 = BBandPass.ar(onset0GrainMacro4, Select.kr(feedback0[46], [osc0Freq4, Select.kr(feedback0[60], [filterData0[4], networkFilters0[4]])]), feedback0[57]);
	osc0Filter5 = BBandPass.ar(onset0GrainMacro5, Select.kr(feedback0[46], [osc0Freq5, Select.kr(feedback0[60], [filterData0[5], networkFilters0[5]])]), feedback0[57]);
	osc0Filter6 = BBandPass.ar(onset0GrainMacro6, Select.kr(feedback0[46], [osc0Freq6, Select.kr(feedback0[60], [filterData0[6], networkFilters0[6]])]), feedback0[57]);
	osc0Filter7 = BBandPass.ar(onset0GrainMacro7, Select.kr(feedback0[46], [osc0Freq7, Select.kr(feedback0[60], [filterData0[7], networkFilters0[7]])]), feedback0[57]);
	osc0Filter8 = BBandPass.ar(onset0GrainMacro8, Select.kr(feedback0[46], [osc0Freq8, Select.kr(feedback0[60], [filterData0[8], networkFilters0[8]])]), feedback0[57]);
	osc0Filter9 = BBandPass.ar(onset0GrainMacro9, Select.kr(feedback0[46], [osc0Freq9, Select.kr(feedback0[60], [filterData0[9], networkFilters0[9]])]), feedback0[57]);
	osc0Filter10 = BBandPass.ar(onset0GrainMacro10, Select.kr(feedback0[46], [osc0Freq10, Select.kr(feedback0[60], [filterData0[10], networkFilters0[10]])]), feedback0[57]);
	osc0Filter11 = BBandPass.ar(onset0GrainMacro11, Select.kr(feedback0[46], [osc0Freq11, Select.kr(feedback0[60], [filterData0[11], networkFilters0[11]])]), feedback0[57]);
	osc0Filter12 = BBandPass.ar(onset0GrainMacro12, Select.kr(feedback0[46], [osc0Freq12, Select.kr(feedback0[60], [filterData0[12], networkFilters0[12]])]), feedback0[57]);

// Degrade audio fidelity of Granular synthesizers set in GUI
	osc0Decimate0 = Decimator.ar(osc0Filter0, Select.kr(feedback0[9], [44100, 44100/feedback0[54]]), bitRate0);
	osc0Decimate1 = Decimator.ar(osc0Filter1, Select.kr(feedback0[9], [44100, 44100/feedback0[54]]), bitRate0);
	osc0Decimate2 = Decimator.ar(osc0Filter2, Select.kr(feedback0[9], [44100, 44100/feedback0[54]]), bitRate0);
	osc0Decimate3 = Decimator.ar(osc0Filter3, Select.kr(feedback0[9], [44100, 44100/feedback0[54]]), bitRate0);
	osc0Decimate4 = Decimator.ar(osc0Filter4, Select.kr(feedback0[9], [44100, 44100/feedback0[54]]), bitRate0);
	osc0Decimate5 = Decimator.ar(osc0Filter5, Select.kr(feedback0[9], [44100, 44100/feedback0[54]]), bitRate0);
	osc0Decimate6 = Decimator.ar(osc0Filter6, Select.kr(feedback0[9], [44100, 44100/feedback0[54]]), bitRate0);
	osc0Decimate7 = Decimator.ar(osc0Filter7, Select.kr(feedback0[9], [44100, 44100/feedback0[54]]), bitRate0);
	osc0Decimate8 = Decimator.ar(osc0Filter8, Select.kr(feedback0[9], [44100, 44100/feedback0[54]]), bitRate0);
	osc0Decimate9 = Decimator.ar(osc0Filter9, Select.kr(feedback0[9], [44100, 44100/feedback0[54]]), bitRate0);
	osc0Decimate10 = Decimator.ar(osc0Filter10, Select.kr(feedback0[9], [44100, 44100/feedback0[54]]), bitRate0);
	osc0Decimate11 = Decimator.ar(osc0Filter11, Select.kr(feedback0[9], [44100, 44100/feedback0[54]]), bitRate0);
	osc0Decimate12 = Decimator.ar(osc0Filter12, Select.kr(feedback0[9], [44100, 44100/feedback0[54]]), bitRate0);

// Cap amplitudes of granular synthesizers to limit clipping
	osc0Limiter0 = Select.ar(feedback0[9], [onset0GrainMacro0, osc0Decimate0]) * Select.kr(feedback0[46], [0.5, amplitude0]);
	osc0Limiter1 = Select.ar(feedback0[9], [onset0GrainMacro1, osc0Decimate1]) * Select.kr(feedback0[46], [0.5, amplitude1]);
	osc0Limiter2 = Select.ar(feedback0[9], [onset0GrainMacro2, osc0Decimate2]) * Select.kr(feedback0[46], [0.5, amplitude2]);
	osc0Limiter3 = Select.ar(feedback0[9], [onset0GrainMacro3, osc0Decimate3]) * Select.kr(feedback0[46], [0.5, amplitude3]);
	osc0Limiter4 = Select.ar(feedback0[9], [onset0GrainMacro4, osc0Decimate4]) * Select.kr(feedback0[46], [0.5, amplitude4]);
	osc0Limiter5 = Select.ar(feedback0[9], [onset0GrainMacro5, osc0Decimate5]) * Select.kr(feedback0[46], [0.5, amplitude5]);
	osc0Limiter6 = Select.ar(feedback0[9], [onset0GrainMacro6, osc0Decimate6]) * Select.kr(feedback0[46], [0.5, amplitude6]);
	osc0Limiter7 = Select.ar(feedback0[9], [onset0GrainMacro7, osc0Decimate7]) * Select.kr(feedback0[46], [0.5, amplitude7]);
	osc0Limiter8 = Select.ar(feedback0[9], [onset0GrainMacro8, osc0Decimate8]) * Select.kr(feedback0[46], [0.5, amplitude8]);
	osc0Limiter9 = Select.ar(feedback0[9], [onset0GrainMacro9, osc0Decimate9]) * Select.kr(feedback0[46], [0.5, amplitude9]);
	osc0Limiter10 = Select.ar(feedback0[9], [onset0GrainMacro10, osc0Decimate10]) * Select.kr(feedback0[46], [0.5, amplitude10]);
	osc0Limiter11 = Select.ar(feedback0[9], [onset0GrainMacro11, osc0Decimate11]) * Select.kr(feedback0[46], [0.5, amplitude11]);
	osc0Limiter12 = Select.ar(feedback0[9], [onset0GrainMacro12, osc0Decimate12]) * Select.kr(feedback0[46], [0.5, amplitude12]);

	grain0PitchArray0 = [pitchChooser0, pitchChooser1, pitchChooser2, pitchChooser3, pitchChooser4, pitchChooser5, pitchChooser6, pitchChooser7, pitchChooser8, pitchChooser9, pitchChooser10, pitchChooser11, pitchChooser12];

	onsetDuration0Array0 = [duration0, duration1, duration2, duration3, duration4, duration5, duration6, duration7, duration8, duration9, duration10, duration11, duration12].min(4);

	positionArray0 = [position0, position1, position2, position3, position4, position5, position6, position7, position8, position9, position10, position11, position12];

// Output granular synthesizers to audio bus
	Out.ar(~triggerOut0, LPF.ar([osc0Limiter0, osc0Limiter1, osc0Limiter2, osc0Limiter3, osc0Limiter4, osc0Limiter5, osc0Limiter6, osc0Limiter7, osc0Limiter8, osc0Limiter9, osc0Limiter10, osc0Limiter11, osc0Limiter12], 20000));

// Output fractal data to control bus
	Out.kr(~duration0Bus0, onsetDuration0Array0);

	Out.kr(~grainPositionBus0, positionArray0/~warpBuffer0[0].numFrames);

	Out.kr(~grainPitch0Bus0, grain0PitchArray0);

	Out.kr(~filterFreqBus0, [osc0Freq0, osc0Freq1, osc0Freq2, osc0Freq3, osc0Freq4, osc0Freq5, osc0Freq6, osc0Freq7, osc0Freq8, osc0Freq9, osc0Freq10, osc0Freq11, osc0Freq12]);

	}).send(s);

//Granular Synths triggered by onsets of Control Two
	SynthDef(\macroGranulator1,{
	arg onset1Duration0 = 1, onset1Duration1 = 1, onset1Duration2 = 1, onset1Duration3 = 1, onset1Duration4 = 1, onset1Duration5 = 1, onset1Duration6 = 1, onset1Duration7 = 1, onset1Duration8 = 1, onset1Duration9 = 1, onset1Duration10 = 1, onset1Duration11 = 1, onset1Duration12 = 1, networkOnsets1 = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
	grain1Pitch0 = 1, grain1Pitch1 = 1, grain1Pitch2 = 1, grain1Pitch3 = 1, grain1Pitch4 = 1, grain1Pitch5 = 1, grain1Pitch6 = 1, grain1Pitch7 = 1, grain1Pitch8 = 1, grain1Pitch9 = 1, grain1Pitch10 = 1, grain1Pitch11 = 1, grain1Pitch12 = 1, envelopeType = -1,

	fractal1Grain0 = 0, fractal1Grain1 = 0, fractal1Grain2 = 0, fractal1Grain3 = 0, fractal1Grain4 = 0, fractal1Grain5 = 0, fractal1Grain6 = 0, fractal1Grain7 = 0, fractal1Grain8 = 0, fractal1Grain9 = 0, fractal1Grain10 = 0, fractal1Grain11 = 0, fractal1Grain12 = 0,

	osc1Freq0 = 400, osc1Freq1 = 400, osc1Freq2 = 400, osc1Freq3 = 400, osc1Freq4 = 400, osc1Freq5 = 400, osc1Freq6 = 400, osc1Freq7 = 400, osc1Freq8 = 400, osc1Freq9 = 400, osc1Freq10 = 400, osc1Freq11 = 400, osc1Freq12 = 400,

	amplitude0 = 0, amplitude1 = 0, amplitude2 = 0, amplitude3 = 0, amplitude4 = 0, amplitude5 = 0, amplitude6 = 0, amplitude7 = 0, amplitude8 = 0, amplitude9 = 0, amplitude10 = 0, amplitude11 = 0, amplitude12 = 0,

	grain1Attack0 = 0.1, grain1Attack1 = 0.1, grain1Attack2 = 0.1, grain1Attack3 = 0.1, grain1Attack4 = 0.1, grain1Attack5 = 0.1, grain1Attack6 = 0.1, grain1Attack7 = 0.1, grain1Attack8 = 0.1, grain1Attack9 = 0.1, grain1Attack10 = 0.1, grain1Attack11 = 0.1, grain1Attack12 = 0.1,

	grain1Release0 = 0.1,  grain1Release1 = 0.1, grain1Release2 = 0.1, grain1Release3 = 0.1, grain1Release4 = 0.1, grain1Release5 = 0.1, grain1Release6 = 0.1, grain1Release7 = 0.1, grain1Release8 = 0.1, grain1Release9 = 0.1, grain1Release10 = 0.1, grain1Release11 = 0.1, grain1Release12 = 0.1,

	interpolation = 4, bitRate0 = 16, networkFilters1 = #[0,0,0,0,0,0,0,0,0,0,0,0,0], pitchTrackOn = 0;

	var onsets0, onsets1, onsets2, envelopes0, envelopes1, envelopes2, positionArray1, filterData1;

	var onsetDuration0Array0, onsetDuration1Array0, networkChooser0, feedback0, grain0PitchArray0, grain1PitchArray0, grain2PitchArray0;

	var onset1GrainMacro0, onset1GrainMacro1, onset1GrainMacro2, onset1GrainMacro3, onset1GrainMacro4, onset1GrainMacro5, onset1GrainMacro6, onset1GrainMacro7, onset1GrainMacro8, onset1GrainMacro9, onset1GrainMacro10, onset1GrainMacro11, onset1GrainMacro12,  onset0Mix0, onset1Mix0;

	var osc0Decimate0, osc0Decimate1, osc0Decimate2, osc0Decimate3, osc0Decimate4, osc0Decimate5, osc0Decimate6, osc0Decimate7, osc0Decimate8, osc0Decimate9, osc0Decimate10, osc0Decimate11, osc0Decimate12;

	var osc0Limiter0, osc0Limiter1, osc0Limiter2, osc0Limiter3, osc0Limiter4, osc0Limiter5, osc0Limiter6, osc0Limiter7, osc0Limiter8, osc0Limiter9, osc0Limiter10, osc0Limiter11, osc0Limiter12;

	var pitchChooser0, pitchChooser1, pitchChooser2, pitchChooser3, pitchChooser4, pitchChooser5, pitchChooser6, pitchChooser7, pitchChooser8, pitchChooser9, pitchChooser10, pitchChooser11, pitchChooser12;

	var position0, position1, position2, position3, position4, position5, position6, position7, position8, position9, position10, position11, position12;

	var duration0, duration1, duration2, duration3, duration4, duration5, duration6, duration7, duration8, duration9, duration10, duration11, duration12;

	var osc0Filter0, osc0Filter1, osc0Filter2, osc0Filter3, osc0Filter4, osc0Filter5, osc0Filter6, osc0Filter7, osc0Filter8, osc0Filter9, osc0Filter10, osc0Filter11, osc0Filter12, pitchTracker;

	onsetDuration1Array0 = [onset1Duration0, onset1Duration1, onset1Duration2, onset1Duration3, onset1Duration4, onset1Duration5, onset1Duration6, onset1Duration7, onset1Duration8, onset1Duration9, onset1Duration10, onset1Duration11, onset1Duration12];

// Collect onsets for control two from control bus
	onsets1 = In.kr(~onset1Bus0, 13);

// Collect onsets for control two from control bus
	envelopes1 = In.kr(~envelopeBus1, 13);

// Collect onsets for control two from control bus
	filterData1 = In.kr(~filterTracker1, 13);

	feedback0 = In.kr(~gui0Bus0, 63);

	networkChooser0 = feedback0[60];

	pitchTracker = feedback0[25];

// Fractal process for playback rate of each granular synthesizer
	pitchChooser0 = Gate.kr(Select.kr(fractal1Grain0, [grain1Pitch0, grain1Pitch0 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets1[0], networkOnsets1[0]]));
	pitchChooser1 = Gate.kr(Select.kr(fractal1Grain1, [grain1Pitch1, grain1Pitch1 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets1[1], networkOnsets1[1]]));
	pitchChooser2 = Gate.kr(Select.kr(fractal1Grain2, [grain1Pitch2, grain1Pitch2 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets1[2], networkOnsets1[2]]));
	pitchChooser3 = Gate.kr(Select.kr(fractal1Grain3, [grain1Pitch3, grain1Pitch3 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets1[3], networkOnsets1[3]]));
	pitchChooser4 = Gate.kr(Select.kr(fractal1Grain4, [grain1Pitch4, grain1Pitch4 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets1[4], networkOnsets1[4]]));
	pitchChooser5 = Gate.kr(Select.kr(fractal1Grain5, [grain1Pitch5, grain1Pitch5 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets1[5], networkOnsets1[5]]));
	pitchChooser6 = Gate.kr(Select.kr(fractal1Grain6, [grain1Pitch6, grain1Pitch6 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets1[6], networkOnsets1[6]]));
	pitchChooser7 = Gate.kr(Select.kr(fractal1Grain7, [grain1Pitch7, grain1Pitch7 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets1[7], networkOnsets1[7]]));
	pitchChooser8 = Gate.kr(Select.kr(fractal1Grain8, [grain1Pitch8, grain1Pitch8 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets1[8], networkOnsets1[8]]));
	pitchChooser9 = Gate.kr(Select.kr(fractal1Grain9, [grain1Pitch9, grain1Pitch9 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets1[9], networkOnsets1[9]]));
	pitchChooser10 = Gate.kr(Select.kr(fractal1Grain10, [grain1Pitch10, grain1Pitch10 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets1[10], networkOnsets1[10]]));
	pitchChooser11 = Gate.kr(Select.kr(fractal1Grain11, [grain1Pitch11, grain1Pitch11 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets1[11], networkOnsets1[11]]));
	pitchChooser12 = Gate.kr(Select.kr(fractal1Grain12, [grain1Pitch12, grain1Pitch12 * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets1[12], networkOnsets1[12]]));

// Duration divided by result of fractal process for playback rate of each granular synthesizer
	duration0 = (onset1Duration0/(pitchChooser0 * 2)).abs.min(2);
	duration1 = (onset1Duration1/(pitchChooser1 * 2)).abs.min(2);
	duration2 = (onset1Duration2/(pitchChooser2 * 2)).abs.min(2);
	duration3 = (onset1Duration3/(pitchChooser3 * 2)).abs.min(2);
	duration4 = (onset1Duration4/(pitchChooser4 * 2)).abs.min(2);
	duration5 = (onset1Duration5/(pitchChooser5 * 2)).abs.min(2);
	duration6 = (onset1Duration6/(pitchChooser6 * 2)).abs.min(2);
	duration7 = (onset1Duration7/(pitchChooser7 * 2)).abs.min(2);
	duration8 = (onset1Duration8/(pitchChooser8 * 2)).abs.min(2);
	duration9 = (onset1Duration9/(pitchChooser9 * 2)).abs.min(2);
	duration10 = (onset1Duration10/(pitchChooser10 * 2)).abs.min(2);
	duration11 = (onset1Duration11/(pitchChooser11 * 2)).abs.min(2);
	duration12 = (onset1Duration12/(pitchChooser12 * 2)).abs.min(2);

// Fractal process for buffer position of each granular synthesizer
	position0 = Gate.kr(PinkNoise.kr(~warpBuffer1[0].numFrames)/(~warpBuffer1[0].numFrames), Select.kr(networkChooser0,[onsets1[0], networkOnsets1[0]]));
	position1 = Gate.kr(PinkNoise.kr(~warpBuffer1[1].numFrames)/(~warpBuffer1[1].numFrames), Select.kr(networkChooser0,[onsets1[1], networkOnsets1[1]]));
	position2 = Gate.kr(PinkNoise.kr(~warpBuffer1[2].numFrames)/(~warpBuffer1[2].numFrames), Select.kr(networkChooser0,[onsets1[2], networkOnsets1[2]]));
	position3 = Gate.kr(PinkNoise.kr(~warpBuffer1[3].numFrames)/(~warpBuffer1[3].numFrames), Select.kr(networkChooser0,[onsets1[3], networkOnsets1[3]]));
	position4 = Gate.kr(PinkNoise.kr(~warpBuffer1[4].numFrames)/(~warpBuffer1[4].numFrames), Select.kr(networkChooser0,[onsets1[4], networkOnsets1[4]]));
	position5 = Gate.kr(PinkNoise.kr(~warpBuffer1[5].numFrames)/(~warpBuffer1[5].numFrames), Select.kr(networkChooser0,[onsets1[5], networkOnsets1[5]]));
	position6 = Gate.kr(PinkNoise.kr(~warpBuffer1[6].numFrames)/(~warpBuffer1[6].numFrames), Select.kr(networkChooser0,[onsets1[6], networkOnsets1[6]]));
	position7 = Gate.kr(PinkNoise.kr(~warpBuffer1[7].numFrames)/(~warpBuffer1[7].numFrames), Select.kr(networkChooser0,[onsets1[7], networkOnsets1[7]]));
	position8 = Gate.kr(PinkNoise.kr(~warpBuffer1[8].numFrames)/(~warpBuffer1[8].numFrames), Select.kr(networkChooser0,[onsets1[8], networkOnsets1[8]]));
	position9 = Gate.kr(PinkNoise.kr(~warpBuffer1[0].numFrames)/(~warpBuffer1[9].numFrames), Select.kr(networkChooser0,[onsets1[9], networkOnsets1[9]]));
	position10 = Gate.kr(PinkNoise.kr(~warpBuffer1[10].numFrames)/(~warpBuffer1[10].numFrames), Select.kr(networkChooser0,[onsets1[10], networkOnsets1[10]]));
	position11 = Gate.kr(PinkNoise.kr(~warpBuffer1[11].numFrames)/(~warpBuffer1[11].numFrames), Select.kr(networkChooser0,[onsets1[11], networkOnsets1[11]]));
	position12 = Gate.kr(PinkNoise.kr(~warpBuffer1[12].numFrames)/(~warpBuffer1[12].numFrames), Select.kr(networkChooser0,[onsets1[12], networkOnsets1[12]]));

// Granular synthesizer UGens controlled by envelopes
	onset1GrainMacro0 = Warp1.ar(1, ~warpBuffer1[0].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets1[0], networkOnsets1[0]]), BufRateScale.kr(~warpBuffer1[0].bufnum), position0, ~warpBuffer1[0].numFrames, 0, position0, ~warpBuffer1[0].numFrames)/~warpBuffer1[0].numFrames) * filterData1[0], pitchChooser0, 0.2, -1, 8) * envelopes1[0];
	onset1GrainMacro1 = Warp1.ar(1, ~warpBuffer1[1].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets1[1], networkOnsets1[1]]), BufRateScale.kr(~warpBuffer1[1].bufnum), position1, ~warpBuffer1[1].numFrames, 0, position1, ~warpBuffer1[1].numFrames)/~warpBuffer1[1].numFrames) * filterData1[1], pitchChooser1, 0.2, -1, 8) * envelopes1[1];
	onset1GrainMacro2 = Warp1.ar(1, ~warpBuffer1[2].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets1[2], networkOnsets1[2]]), BufRateScale.kr(~warpBuffer1[2].bufnum), position2, ~warpBuffer1[2].numFrames, 0, position2, ~warpBuffer1[2].numFrames)/~warpBuffer1[2].numFrames) * filterData1[2], pitchChooser2, 0.2, -1, 8) * envelopes1[2];
	onset1GrainMacro3 = Warp1.ar(1, ~warpBuffer1[3].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets1[3], networkOnsets1[3]]), BufRateScale.kr(~warpBuffer1[3].bufnum), position3, ~warpBuffer1[3].numFrames, 0, position3, ~warpBuffer1[3].numFrames)/~warpBuffer1[3].numFrames) * filterData1[3], pitchChooser3, 0.2, -1, 8) * envelopes1[3];
	onset1GrainMacro4 = Warp1.ar(1, ~warpBuffer1[4].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets1[4], networkOnsets1[4]]), BufRateScale.kr(~warpBuffer1[4].bufnum), position4, ~warpBuffer1[4].numFrames, 0, position4, ~warpBuffer1[4].numFrames)/~warpBuffer1[4].numFrames) * filterData1[4], pitchChooser4, 0.2, -1, 8) * envelopes1[4];
	onset1GrainMacro5 = Warp1.ar(1, ~warpBuffer1[5].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets1[5], networkOnsets1[5]]), BufRateScale.kr(~warpBuffer1[5].bufnum), position5, ~warpBuffer1[5].numFrames, 0, position5, ~warpBuffer1[5].numFrames)/~warpBuffer1[5].numFrames) * filterData1[5], pitchChooser5, 0.2, -1, 8) * envelopes1[5];
	onset1GrainMacro6 = Warp1.ar(1, ~warpBuffer1[6].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets1[6], networkOnsets1[6]]), BufRateScale.kr(~warpBuffer1[6].bufnum), position6, ~warpBuffer1[6].numFrames, 0, position6, ~warpBuffer1[6].numFrames)/~warpBuffer1[6].numFrames) * filterData1[6], pitchChooser6, 0.2, -1, 8) * envelopes1[6];
	onset1GrainMacro7 = Warp1.ar(1, ~warpBuffer1[7].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets1[7], networkOnsets1[7]]), BufRateScale.kr(~warpBuffer1[7].bufnum), position7, ~warpBuffer1[7].numFrames, 0, position7, ~warpBuffer1[7].numFrames)/~warpBuffer1[7].numFrames) * filterData1[7], pitchChooser7, 0.2, -1, 8) * envelopes1[7];
	onset1GrainMacro8 = Warp1.ar(1, ~warpBuffer1[8].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets1[8], networkOnsets1[8]]), BufRateScale.kr(~warpBuffer1[8].bufnum), position8, ~warpBuffer1[8].numFrames, 0, position8, ~warpBuffer1[8].numFrames)/~warpBuffer1[8].numFrames) * filterData1[8], pitchChooser8, 0.2, -1, 8) * envelopes1[8];
	onset1GrainMacro9 = Warp1.ar(1, ~warpBuffer1[9].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets1[9], networkOnsets1[9]]), BufRateScale.kr(~warpBuffer1[9].bufnum), position9, ~warpBuffer1[9].numFrames, 0, position9, ~warpBuffer1[9].numFrames)/~warpBuffer1[9].numFrames) * filterData1[9], pitchChooser9, 0.2, -1, 8) * envelopes1[9];
	onset1GrainMacro10 = Warp1.ar(1, ~warpBuffer1[10].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets1[10], networkOnsets1[10]]), BufRateScale.kr(~warpBuffer1[10].bufnum), position10, ~warpBuffer1[10].numFrames, 0, position10, ~warpBuffer1[10].numFrames)/~warpBuffer1[10].numFrames) * filterData1[10], pitchChooser10, 0.2, -1, 8) * envelopes1[10];
	onset1GrainMacro11 = Warp1.ar(1, ~warpBuffer1[11].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets1[11], networkOnsets1[11]]), BufRateScale.kr(~warpBuffer1[11].bufnum), position11, ~warpBuffer1[11].numFrames, 0, position11, ~warpBuffer1[11].numFrames)/~warpBuffer1[11].numFrames) * filterData1[11], pitchChooser11, 0.2, -1, 8) * envelopes1[11];
	onset1GrainMacro12 = Warp1.ar(1, ~warpBuffer1[12].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets1[12], networkOnsets1[12]]), BufRateScale.kr(~warpBuffer1[12].bufnum), position12, ~warpBuffer1[12].numFrames, 0, position12, ~warpBuffer1[12].numFrames)/~warpBuffer1[12].numFrames) * filterData1[12], pitchChooser12, 0.2, -1, 8) * envelopes1[12];

// Filter each granular synthesizer	controlled by GUI or Spectral Following Process
	osc0Filter0 = BBandPass.ar(onset1GrainMacro0, Select.kr(feedback0[47], [osc1Freq0, Select.kr(feedback0[60], [filterData1[0], networkFilters1[0]])]), feedback0[58]);
	osc0Filter1 = BBandPass.ar(onset1GrainMacro1, Select.kr(feedback0[47], [osc1Freq1, Select.kr(feedback0[60], [filterData1[1], networkFilters1[1]])]), feedback0[58]);
	osc0Filter2 = BBandPass.ar(onset1GrainMacro2, Select.kr(feedback0[47], [osc1Freq2, Select.kr(feedback0[60], [filterData1[2], networkFilters1[2]])]), feedback0[58]);
	osc0Filter3 = BBandPass.ar(onset1GrainMacro3, Select.kr(feedback0[47], [osc1Freq3, Select.kr(feedback0[60], [filterData1[3], networkFilters1[3]])]), feedback0[58]);
	osc0Filter4 = BBandPass.ar(onset1GrainMacro4, Select.kr(feedback0[47], [osc1Freq4, Select.kr(feedback0[60], [filterData1[4], networkFilters1[4]])]), feedback0[58]);
	osc0Filter5 = BBandPass.ar(onset1GrainMacro5, Select.kr(feedback0[47], [osc1Freq5, Select.kr(feedback0[60], [filterData1[5], networkFilters1[5]])]), feedback0[58]);
	osc0Filter6 = BBandPass.ar(onset1GrainMacro6, Select.kr(feedback0[47], [osc1Freq6, Select.kr(feedback0[60], [filterData1[6], networkFilters1[6]])]), feedback0[58]);
	osc0Filter7 = BBandPass.ar(onset1GrainMacro7, Select.kr(feedback0[47], [osc1Freq7, Select.kr(feedback0[60], [filterData1[7], networkFilters1[7]])]), feedback0[58]);
	osc0Filter8 = BBandPass.ar(onset1GrainMacro8, Select.kr(feedback0[47], [osc1Freq8, Select.kr(feedback0[60], [filterData1[8], networkFilters1[8]])]), feedback0[58]);
	osc0Filter9 = BBandPass.ar(onset1GrainMacro9, Select.kr(feedback0[47], [osc1Freq9, Select.kr(feedback0[60], [filterData1[9], networkFilters1[9]])]), feedback0[58]);
	osc0Filter10 = BBandPass.ar(onset1GrainMacro10, Select.kr(feedback0[47], [osc1Freq10, Select.kr(feedback0[60], [filterData1[10], networkFilters1[10]])]), feedback0[58]);
	osc0Filter11 = BBandPass.ar(onset1GrainMacro11, Select.kr(feedback0[47], [osc1Freq11, Select.kr(feedback0[60], [filterData1[11], networkFilters1[11]])]), feedback0[58]);
	osc0Filter12 = BBandPass.ar(onset1GrainMacro12, Select.kr(feedback0[47], [osc1Freq12, Select.kr(feedback0[60], [filterData1[12], networkFilters1[12]])]), feedback0[58]);

// Degrade audio fidelity of Granular synthesizers set in GUI
	osc0Decimate0 = Decimator.ar(osc0Filter0, Select.kr(feedback0[10], [44100, 44100/feedback0[55]]), bitRate0);
	osc0Decimate1 = Decimator.ar(osc0Filter1, Select.kr(feedback0[10], [44100, 44100/feedback0[55]]), bitRate0);
	osc0Decimate2 = Decimator.ar(osc0Filter2, Select.kr(feedback0[10], [44100, 44100/feedback0[55]]), bitRate0);
	osc0Decimate3 = Decimator.ar(osc0Filter3, Select.kr(feedback0[10], [44100, 44100/feedback0[55]]), bitRate0);
	osc0Decimate4 = Decimator.ar(osc0Filter4, Select.kr(feedback0[10], [44100, 44100/feedback0[55]]), bitRate0);
	osc0Decimate5 = Decimator.ar(osc0Filter5, Select.kr(feedback0[10], [44100, 44100/feedback0[55]]), bitRate0);
	osc0Decimate6 = Decimator.ar(osc0Filter6, Select.kr(feedback0[10], [44100, 44100/feedback0[55]]), bitRate0);
	osc0Decimate7 = Decimator.ar(osc0Filter7, Select.kr(feedback0[10], [44100, 44100/feedback0[55]]), bitRate0);
	osc0Decimate8 = Decimator.ar(osc0Filter8, Select.kr(feedback0[10], [44100, 44100/feedback0[55]]), bitRate0);
	osc0Decimate9 = Decimator.ar(osc0Filter9, Select.kr(feedback0[10], [44100, 44100/feedback0[55]]), bitRate0);
	osc0Decimate10 = Decimator.ar(osc0Filter10, Select.kr(feedback0[10], [44100, 44100/feedback0[55]]), bitRate0);
	osc0Decimate11 = Decimator.ar(osc0Filter11, Select.kr(feedback0[10], [44100, 44100/feedback0[55]]), bitRate0);
	osc0Decimate12 = Decimator.ar(osc0Filter12, Select.kr(feedback0[10], [44100, 44100/feedback0[55]]), bitRate0);

// Cap amplitudes of granular synthesizers to limit clipping
	osc0Limiter0 = Select.ar(feedback0[10], [onset1GrainMacro0, osc0Decimate0]) * Select.kr(feedback0[47], [0.5, amplitude0]);
	osc0Limiter1 = Select.ar(feedback0[10], [onset1GrainMacro1, osc0Decimate1]) * Select.kr(feedback0[47], [0.5, amplitude1]);
	osc0Limiter2 = Select.ar(feedback0[10], [onset1GrainMacro2, osc0Decimate2]) * Select.kr(feedback0[47], [0.5, amplitude2]);
	osc0Limiter3 = Select.ar(feedback0[10], [onset1GrainMacro3, osc0Decimate3]) * Select.kr(feedback0[47], [0.5, amplitude3]);
	osc0Limiter4 = Select.ar(feedback0[10], [onset1GrainMacro4, osc0Decimate4]) * Select.kr(feedback0[47], [0.5, amplitude4]);
	osc0Limiter5 = Select.ar(feedback0[10], [onset1GrainMacro5, osc0Decimate5]) * Select.kr(feedback0[47], [0.5, amplitude5]);
	osc0Limiter6 = Select.ar(feedback0[10], [onset1GrainMacro6, osc0Decimate6]) * Select.kr(feedback0[47], [0.5, amplitude6]);
	osc0Limiter7 = Select.ar(feedback0[10], [onset1GrainMacro7, osc0Decimate7]) * Select.kr(feedback0[47], [0.5, amplitude7]);
	osc0Limiter8 = Select.ar(feedback0[10], [onset1GrainMacro8, osc0Decimate8]) * Select.kr(feedback0[47], [0.5, amplitude8]);
	osc0Limiter9 = Select.ar(feedback0[10], [onset1GrainMacro9, osc0Decimate9]) * Select.kr(feedback0[47], [0.5, amplitude9]);
	osc0Limiter10 = Select.ar(feedback0[10], [onset1GrainMacro10, osc0Decimate10]) * Select.kr(feedback0[47], [0.5, amplitude10]);
	osc0Limiter11 = Select.ar(feedback0[10], [onset1GrainMacro11, osc0Decimate11]) * Select.kr(feedback0[47], [0.5, amplitude11]);
	osc0Limiter12 = Select.ar(feedback0[10], [onset1GrainMacro12, osc0Decimate12]) * Select.kr(feedback0[47], [0.5, amplitude12]);

	grain1PitchArray0 = [pitchChooser0, pitchChooser1, pitchChooser2, pitchChooser3, pitchChooser4, pitchChooser5, pitchChooser6, pitchChooser7, pitchChooser8, pitchChooser9, pitchChooser10, pitchChooser11, pitchChooser12];

	onsetDuration1Array0 = [duration0, duration1, duration2, duration3, duration4, duration5, duration6, duration7, duration8, duration9, duration10, duration11, duration12].min(4);

	positionArray1 = [position0, position1, position2, position3, position4, position5, position6, position7, position8, position9, position10, position11, position12];

// Output granular synthesizers to audio bus
	Out.ar(~triggerOut1, LPF.ar([osc0Limiter0, osc0Limiter1, osc0Limiter2, osc0Limiter3, osc0Limiter4, osc0Limiter5, osc0Limiter6, osc0Limiter7, osc0Limiter8, osc0Limiter9, osc0Limiter10, osc0Limiter11, osc0Limiter12], 4000));

// Output fractal data to control bus
	Out.kr(~duration1Bus0, onsetDuration1Array0);

	Out.kr(~grainPositionBus1, positionArray1);

	Out.kr(~grainPitch1Bus0, grain1PitchArray0);

	Out.kr(~filterFreqBus1, [osc1Freq0, osc1Freq1, osc1Freq2, osc1Freq3, osc1Freq4, osc1Freq5, osc1Freq6, osc1Freq7, osc1Freq8, osc1Freq9, osc1Freq10, osc1Freq11, osc1Freq12]);

	}).send(s);

//Granular Synths triggered by onsets of Control Three/Slave
	SynthDef(\macroGranulator2,{
	arg  pitchArray0 = #[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], onsetDuration2Array0 = #[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], networkOnsets2 = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], networkFilters2 = #[0,0,0,0,0,0,0,0,0,0,0,0,0], envelopeFeedback0 = #[0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0],

	fractal2Grain0 = 0, fractal2Grain1 = 0, fractal2Grain2 = 0, fractal2Grain3 = 0, fractal2Grain4 = 0, fractal2Grain5 = 0, fractal2Grain6 = 0, fractal2Grain7 = 0, fractal2Grain8 = 0, fractal2Grain9 = 0, fractal2Grain10 = 0, fractal2Grain11 = 0, fractal2Grain12 = 0,

	interpolation = 4, amplitude0 = 0, amplitude1 = 0, amplitude2 = 0, amplitude3 = 0, amplitude4 = 0, amplitude5 = 0, amplitude6 = 0, amplitude7 = 0, amplitude8 = 0, amplitude9 = 0, amplitude10 = 0, amplitude11 = 0, amplitude12 = 0,

	bitRate0 = 16,

	osc2Freq0 = 400, osc2Freq1 = 400, osc2Freq2 = 400, osc2Freq3 = 400, osc2Freq4 = 400, osc2Freq5 = 400, osc2Freq6 = 400, osc2Freq7 = 400, osc2Freq8 = 400, osc2Freq9 = 400, osc2Freq10 = 400, osc2Freq11 = 400, osc2Freq12 = 400, pitchTrackOn = 0;

	var onsets0, onsets1, onsets2, envelopes0, envelopes1, envelopes2, networkChooser0, feedback0, onsetDuration2ArrayOut0, filterData2;

	var grain2PitchArray0, positionArray2;

	var pitchChooser0, pitchChooser1, pitchChooser2, pitchChooser3, pitchChooser4, pitchChooser5, pitchChooser6, pitchChooser7, pitchChooser8, pitchChooser9, pitchChooser10, pitchChooser11, pitchChooser12;

	var position0, position1, position2, position3, position4, position5, position6, position7, position8, position9, position10, position11, position12;

	var duration0, duration1, duration2, duration3, duration4, duration5, duration6, duration7, duration8, duration9, duration10, duration11, duration12;

	var osc0Decimate0, osc0Decimate1, osc0Decimate2, osc0Decimate3, osc0Decimate4, osc0Decimate5, osc0Decimate6, osc0Decimate7, osc0Decimate8, osc0Decimate9, osc0Decimate10, osc0Decimate11, osc0Decimate12;

	var osc0Limiter0, osc0Limiter1, osc0Limiter2, osc0Limiter3, osc0Limiter4, osc0Limiter5, osc0Limiter6, osc0Limiter7, osc0Limiter8, osc0Limiter9, osc0Limiter10, osc0Limiter11, osc0Limiter12;

	var osc0Filter0, osc0Filter1, osc0Filter2, osc0Filter3, osc0Filter4, osc0Filter5, osc0Filter6, osc0Filter7, osc0Filter8, osc0Filter9, osc0Filter10, osc0Filter11, osc0Filter12;

	var feedback0GrainMacro0, feedback0GrainMacro1, feedback0GrainMacro2, feedback0GrainMacro3, feedback0GrainMacro4, feedback0GrainMacro5, feedback0GrainMacro6, feedback0GrainMacro7, feedback0GrainMacro8, feedback0GrainMacro9, feedback0GrainMacro10, feedback0GrainMacro11, feedback0GrainMacro12, feedback0GrainMacroMix0, outputMix, pitchTracker;
// Collect onsets for control three/slave from control bus
	onsets2 = In.kr(~onset2Bus0, 13);

// Collect envelope for control three/slave from control bus
	envelopes2 = In.kr(~envelopeBus2, 13);

	feedback0 = In.kr(~gui0Bus0, 63);

	filterData2 = In.kr(~filterTracker2, 13);

	networkChooser0 = feedback0[60];

	pitchTracker = feedback0[25];

// Fractal process for playback rate of each granular synthesizer
	pitchChooser0 = Gate.kr(Select.kr(fractal2Grain0, [pitchArray0[0], pitchArray0[0] * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets2[0], networkOnsets2[0]]));
	pitchChooser1 = Gate.kr(Select.kr(fractal2Grain1, [pitchArray0[1], pitchArray0[1] * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets2[1], networkOnsets2[1]]));
	pitchChooser2 = Gate.kr(Select.kr(fractal2Grain2, [pitchArray0[2], pitchArray0[2] * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets2[2], networkOnsets2[2]]));
	pitchChooser3 = Gate.kr(Select.kr(fractal2Grain3, [pitchArray0[3], pitchArray0[3] * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets2[3], networkOnsets2[3]]));
	pitchChooser4 = Gate.kr(Select.kr(fractal2Grain4, [pitchArray0[4], pitchArray0[4] * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets2[4], networkOnsets2[4]]));
	pitchChooser5 = Gate.kr(Select.kr(fractal2Grain5, [pitchArray0[5], pitchArray0[5] * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets2[5], networkOnsets2[5]]));
	pitchChooser6 = Gate.kr(Select.kr(fractal2Grain6, [pitchArray0[6], pitchArray0[6] * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets2[6], networkOnsets2[6]]));
	pitchChooser7 = Gate.kr(Select.kr(fractal2Grain7, [pitchArray0[7], pitchArray0[7] * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets2[7], networkOnsets2[7]]));
	pitchChooser8 = Gate.kr(Select.kr(fractal2Grain8, [pitchArray0[8], pitchArray0[8] * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets2[8], networkOnsets2[8]]));
	pitchChooser9 = Gate.kr(Select.kr(fractal2Grain9, [pitchArray0[9], pitchArray0[9] * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets2[9], networkOnsets2[9]]));
	pitchChooser10 = Gate.kr(Select.kr(fractal2Grain10, [pitchArray0[10], pitchArray0[10] * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets2[10], networkOnsets2[10]]));
	pitchChooser11 = Gate.kr(Select.kr(fractal2Grain11, [pitchArray0[11], pitchArray0[11] * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets2[11], networkOnsets2[11]]));
	pitchChooser12 = Gate.kr(Select.kr(fractal2Grain12, [pitchArray0[12], pitchArray0[12] * PinkNoise.kr(4)]) * Select.kr(pitchTrackOn, [1, pitchTracker]), Select.kr(networkChooser0,[onsets2[12], networkOnsets2[12]]));

// Duration divided by result of fractal process for playback rate of each granular synthesizer

	duration0 = (onsetDuration2Array0[0]/(pitchChooser0 * 2)).abs.min(2);
	duration1 = (onsetDuration2Array0[1]/(pitchChooser1 * 2)).abs.min(2);
	duration2 = (onsetDuration2Array0[2]/(pitchChooser2 * 2)).abs.min(2);
	duration3 = (onsetDuration2Array0[3]/(pitchChooser3 * 2)).abs.min(2);
	duration4 = (onsetDuration2Array0[4]/(pitchChooser4 * 2)).abs.min(2);
	duration5 = (onsetDuration2Array0[5]/(pitchChooser5 * 2)).abs.min(2);
	duration6 = (onsetDuration2Array0[6]/(pitchChooser6 * 2)).abs.min(2);
	duration7 = (onsetDuration2Array0[7]/(pitchChooser7 * 2)).abs.min(2);
	duration8 = (onsetDuration2Array0[8]/(pitchChooser8 * 2)).abs.min(2);
	duration9 = (onsetDuration2Array0[9]/(pitchChooser9 * 2)).abs.min(2);
	duration10 = (onsetDuration2Array0[10]/(pitchChooser10 * 2)).abs.min(2);
	duration11 = (onsetDuration2Array0[11]/(pitchChooser11 * 2)).abs.min(2);
	duration12 = (onsetDuration2Array0[12]/(pitchChooser12 * 2)).abs.min(2);

// Fractal process for buffer position of each granular synthesizer
	position0 = Gate.kr(PinkNoise.kr(~warpBuffer2[0].numFrames)/(~warpBuffer2[0].numFrames), Select.kr(networkChooser0,[onsets2[0], networkOnsets2[0]]));
	position1 = Gate.kr(PinkNoise.kr(~warpBuffer2[1].numFrames)/(~warpBuffer2[1].numFrames), Select.kr(networkChooser0,[onsets2[1], networkOnsets2[1]]));
	position2 = Gate.kr(PinkNoise.kr(~warpBuffer2[2].numFrames)/(~warpBuffer2[2].numFrames), Select.kr(networkChooser0,[onsets2[2], networkOnsets2[2]]));
	position3 = Gate.kr(PinkNoise.kr(~warpBuffer2[3].numFrames)/(~warpBuffer2[3].numFrames), Select.kr(networkChooser0,[onsets2[3], networkOnsets2[3]]));
	position4 = Gate.kr(PinkNoise.kr(~warpBuffer2[4].numFrames)/(~warpBuffer2[4].numFrames), Select.kr(networkChooser0,[onsets2[4], networkOnsets2[4]]));
	position5 = Gate.kr(PinkNoise.kr(~warpBuffer2[5].numFrames)/(~warpBuffer2[5].numFrames), Select.kr(networkChooser0,[onsets2[5], networkOnsets2[5]]));
	position6 = Gate.kr(PinkNoise.kr(~warpBuffer2[6].numFrames)/(~warpBuffer2[6].numFrames), Select.kr(networkChooser0,[onsets2[6], networkOnsets2[6]]));
	position7 = Gate.kr(PinkNoise.kr(~warpBuffer2[7].numFrames)/(~warpBuffer2[7].numFrames), Select.kr(networkChooser0,[onsets2[7], networkOnsets2[7]]));
	position8 = Gate.kr(PinkNoise.kr(~warpBuffer2[8].numFrames)/(~warpBuffer2[8].numFrames), Select.kr(networkChooser0,[onsets2[8], networkOnsets2[8]]));
	position9 = Gate.kr(PinkNoise.kr(~warpBuffer2[0].numFrames)/(~warpBuffer2[9].numFrames), Select.kr(networkChooser0,[onsets2[9], networkOnsets2[9]]));
	position10 = Gate.kr(PinkNoise.kr(~warpBuffer2[10].numFrames)/(~warpBuffer2[10].numFrames), Select.kr(networkChooser0,[onsets2[10], networkOnsets2[10]]));
	position11 = Gate.kr(PinkNoise.kr(~warpBuffer2[11].numFrames)/(~warpBuffer2[11].numFrames), Select.kr(networkChooser0,[onsets2[11], networkOnsets2[11]]));
	position12 = Gate.kr(PinkNoise.kr(~warpBuffer2[12].numFrames)/(~warpBuffer2[12].numFrames), Select.kr(networkChooser0,[onsets2[12], networkOnsets2[12]]));

// Granular synthesizer UGens controlled by envelopes
	feedback0GrainMacro0 = Warp1.ar(1, ~warpBuffer2[0].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets2[0], networkOnsets2[0]]), BufRateScale.kr(~warpBuffer2[0].bufnum), position0, ~warpBuffer2[0].numFrames, 0, position0, ~warpBuffer2[0].numFrames)/~warpBuffer2[0].numFrames) * filterData2[0], pitchChooser0, 0.2, -1, 8) * envelopes2[0];
	feedback0GrainMacro1 = Warp1.ar(1, ~warpBuffer2[1].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets2[1], networkOnsets2[1]]), BufRateScale.kr(~warpBuffer2[1].bufnum), position1, ~warpBuffer2[1].numFrames, 0, position1, ~warpBuffer2[1].numFrames)/~warpBuffer2[1].numFrames) * filterData2[1], pitchChooser1, 0.2, -1, 8) * envelopes2[1];
	feedback0GrainMacro2 = Warp1.ar(1, ~warpBuffer2[2].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets2[2], networkOnsets2[2]]), BufRateScale.kr(~warpBuffer2[2].bufnum), position2, ~warpBuffer2[2].numFrames, 0, position2, ~warpBuffer2[2].numFrames)/~warpBuffer2[2].numFrames) * filterData2[2], pitchChooser2, 0.2, -1, 8) * envelopes2[2];
	feedback0GrainMacro3 = Warp1.ar(1, ~warpBuffer2[3].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets2[3], networkOnsets2[3]]), BufRateScale.kr(~warpBuffer2[3].bufnum), position3, ~warpBuffer2[3].numFrames, 0, position3, ~warpBuffer2[3].numFrames)/~warpBuffer2[3].numFrames) * filterData2[3], pitchChooser3, 0.2, -1, 8) * envelopes2[3];
	feedback0GrainMacro4 = Warp1.ar(1, ~warpBuffer2[4].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets2[4], networkOnsets2[4]]), BufRateScale.kr(~warpBuffer2[4].bufnum), position4, ~warpBuffer2[4].numFrames, 0, position4, ~warpBuffer2[4].numFrames)/~warpBuffer2[4].numFrames) * filterData2[4], pitchChooser4, 0.2, -1, 8) * envelopes2[4];
	feedback0GrainMacro5 = Warp1.ar(1, ~warpBuffer2[5].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets2[5], networkOnsets2[5]]), BufRateScale.kr(~warpBuffer2[5].bufnum), position5, ~warpBuffer2[5].numFrames, 0, position5, ~warpBuffer2[5].numFrames)/~warpBuffer2[5].numFrames) * filterData2[5], pitchChooser5, 0.2, -1, 8) * envelopes2[5];
	feedback0GrainMacro6 = Warp1.ar(1, ~warpBuffer2[6].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets2[6], networkOnsets2[6]]), BufRateScale.kr(~warpBuffer2[6].bufnum), position6, ~warpBuffer2[6].numFrames, 0, position6, ~warpBuffer2[6].numFrames)/~warpBuffer2[6].numFrames) * filterData2[6], pitchChooser6, 0.2, -1, 8) * envelopes2[6];
	feedback0GrainMacro7 = Warp1.ar(1, ~warpBuffer2[7].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets2[7], networkOnsets2[7]]), BufRateScale.kr(~warpBuffer2[7].bufnum), position7, ~warpBuffer2[7].numFrames, 0, position7, ~warpBuffer2[7].numFrames)/~warpBuffer2[7].numFrames) * filterData2[7], pitchChooser7, 0.2, -1, 8) * envelopes2[7];
	feedback0GrainMacro8 = Warp1.ar(1, ~warpBuffer2[8].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets2[8], networkOnsets2[8]]), BufRateScale.kr(~warpBuffer2[8].bufnum), position8, ~warpBuffer2[8].numFrames, 0, position8, ~warpBuffer2[8].numFrames)/~warpBuffer2[8].numFrames) * filterData2[8], pitchChooser8, 0.2, -1, 8) * envelopes2[8];
	feedback0GrainMacro9 = Warp1.ar(1, ~warpBuffer2[9].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets2[9], networkOnsets2[9]]), BufRateScale.kr(~warpBuffer2[9].bufnum), position9, ~warpBuffer2[9].numFrames, 0, position9, ~warpBuffer2[9].numFrames)/~warpBuffer2[9].numFrames) * filterData2[9], pitchChooser9, 0.2, -1, 8) * envelopes2[9];
	feedback0GrainMacro10 = Warp1.ar(1, ~warpBuffer2[10].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets2[10], networkOnsets2[10]]), BufRateScale.kr(~warpBuffer2[10].bufnum), position10, ~warpBuffer2[10].numFrames, 0, position10, ~warpBuffer2[10].numFrames)/~warpBuffer2[10].numFrames) * filterData2[10], pitchChooser10, 0.2, -1, 8) * envelopes2[10];
	feedback0GrainMacro11 = Warp1.ar(1, ~warpBuffer2[11].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets2[11], networkOnsets2[11]]), BufRateScale.kr(~warpBuffer2[11].bufnum), position11, ~warpBuffer2[11].numFrames, 0, position11, ~warpBuffer2[11].numFrames)/~warpBuffer2[11].numFrames) * filterData2[11], pitchChooser11, 0.2, -1, 8) * envelopes2[11];
	feedback0GrainMacro12 = Warp1.ar(1, ~warpBuffer2[12].bufnum, (RedPhasor2.ar(Select.kr(networkChooser0,[onsets2[12], networkOnsets2[12]]), BufRateScale.kr(~warpBuffer2[12].bufnum), position12, ~warpBuffer2[12].numFrames, 0, position12, ~warpBuffer2[12].numFrames)/~warpBuffer2[12].numFrames) * filterData2[12], pitchChooser12, 0.2, -1, 8) * envelopes2[12];

// Filter each granular synthesizer	controlled by GUI or Spectral Following Process
	osc0Filter0 = BBandPass.ar(feedback0GrainMacro0, Select.kr(feedback0[48], [osc2Freq0, Select.kr(feedback0[60], [filterData2[0], networkFilters2[0]])]), feedback0[59]);
	osc0Filter1 = BBandPass.ar(feedback0GrainMacro1, Select.kr(feedback0[48], [osc2Freq1, Select.kr(feedback0[60], [filterData2[1], networkFilters2[1]])]), feedback0[59]);
	osc0Filter2 = BBandPass.ar(feedback0GrainMacro2, Select.kr(feedback0[48], [osc2Freq2, Select.kr(feedback0[60], [filterData2[2], networkFilters2[2]])]), feedback0[59]);
	osc0Filter3 = BBandPass.ar(feedback0GrainMacro3, Select.kr(feedback0[48], [osc2Freq3, Select.kr(feedback0[60], [filterData2[3], networkFilters2[3]])]), feedback0[59]);
	osc0Filter4 = BBandPass.ar(feedback0GrainMacro4, Select.kr(feedback0[48], [osc2Freq4, Select.kr(feedback0[60], [filterData2[4], networkFilters2[4]])]), feedback0[59]);
	osc0Filter5 = BBandPass.ar(feedback0GrainMacro5, Select.kr(feedback0[48], [osc2Freq5, Select.kr(feedback0[60], [filterData2[5], networkFilters2[5]])]), feedback0[59]);
	osc0Filter6 = BBandPass.ar(feedback0GrainMacro6, Select.kr(feedback0[48], [osc2Freq6, Select.kr(feedback0[60], [filterData2[6], networkFilters2[6]])]), feedback0[59]);
	osc0Filter7 = BBandPass.ar(feedback0GrainMacro7, Select.kr(feedback0[48], [osc2Freq7, Select.kr(feedback0[60], [filterData2[7], networkFilters2[7]])]), feedback0[59]);
	osc0Filter8 = BBandPass.ar(feedback0GrainMacro8, Select.kr(feedback0[48], [osc2Freq8, Select.kr(feedback0[60], [filterData2[8], networkFilters2[8]])]), feedback0[59]);
	osc0Filter9 = BBandPass.ar(feedback0GrainMacro9, Select.kr(feedback0[48], [osc2Freq9, Select.kr(feedback0[60], [filterData2[9], networkFilters2[9]])]), feedback0[59]);
	osc0Filter10 = BBandPass.ar(feedback0GrainMacro10, Select.kr(feedback0[48], [osc2Freq10, Select.kr(feedback0[60], [filterData2[10], networkFilters2[10]])]), feedback0[59]);
	osc0Filter11 = BBandPass.ar(feedback0GrainMacro11, Select.kr(feedback0[48], [osc2Freq11, Select.kr(feedback0[60], [filterData2[11], networkFilters2[11]])]), feedback0[59]);
	osc0Filter12 = BBandPass.ar(feedback0GrainMacro12, Select.kr(feedback0[48], [osc2Freq12, Select.kr(feedback0[60], [filterData2[12], networkFilters2[12]])]), feedback0[59]);
// Degrade audio fidelity of Granular synthesizers set in GUI
	osc0Decimate0 = Decimator.ar(osc0Filter0, Select.kr(feedback0[23], [44100, 44100/feedback0[56]]), bitRate0);
	osc0Decimate1 = Decimator.ar(osc0Filter1, Select.kr(feedback0[23], [44100, 44100/feedback0[56]]), bitRate0);
	osc0Decimate2 = Decimator.ar(osc0Filter2, Select.kr(feedback0[23], [44100, 44100/feedback0[56]]), bitRate0);
	osc0Decimate3 = Decimator.ar(osc0Filter3, Select.kr(feedback0[23], [44100, 44100/feedback0[56]]), bitRate0);
	osc0Decimate4 = Decimator.ar(osc0Filter4, Select.kr(feedback0[23], [44100, 44100/feedback0[56]]), bitRate0);
	osc0Decimate5 = Decimator.ar(osc0Filter5, Select.kr(feedback0[23], [44100, 44100/feedback0[56]]), bitRate0);
	osc0Decimate6 = Decimator.ar(osc0Filter6, Select.kr(feedback0[23], [44100, 44100/feedback0[56]]), bitRate0);
	osc0Decimate7 = Decimator.ar(osc0Filter7, Select.kr(feedback0[23], [44100, 44100/feedback0[56]]), bitRate0);
	osc0Decimate8 = Decimator.ar(osc0Filter8, Select.kr(feedback0[23], [44100, 44100/feedback0[56]]), bitRate0);
	osc0Decimate9 = Decimator.ar(osc0Filter9, Select.kr(feedback0[23], [44100, 44100/feedback0[56]]), bitRate0);
	osc0Decimate10 = Decimator.ar(osc0Filter10, Select.kr(feedback0[23], [44100, 44100/feedback0[56]]), bitRate0);
	osc0Decimate11 = Decimator.ar(osc0Filter11, Select.kr(feedback0[23], [44100, 44100/feedback0[56]]), bitRate0);
	osc0Decimate12 = Decimator.ar(osc0Filter12, Select.kr(feedback0[23], [44100, 44100/feedback0[56]]), bitRate0);

// Cap amplitudes of granular synthesizers to limit clipping
	osc0Limiter0 = Select.ar(feedback0[23], [feedback0GrainMacro0, osc0Decimate0]) * Select.kr(feedback0[48], [0.5, amplitude0]);
	osc0Limiter1 = Select.ar(feedback0[23], [feedback0GrainMacro1, osc0Decimate1]) * Select.kr(feedback0[48], [0.5, amplitude1]);
	osc0Limiter2 = Select.ar(feedback0[23], [feedback0GrainMacro2, osc0Decimate2]) * Select.kr(feedback0[48], [0.5, amplitude2]);
	osc0Limiter3 = Select.ar(feedback0[23], [feedback0GrainMacro3, osc0Decimate3]) * Select.kr(feedback0[48], [0.5, amplitude3]);
	osc0Limiter4 = Select.ar(feedback0[23], [feedback0GrainMacro4, osc0Decimate4]) * Select.kr(feedback0[48], [0.5, amplitude4]);
	osc0Limiter5 = Select.ar(feedback0[23], [feedback0GrainMacro5, osc0Decimate5]) * Select.kr(feedback0[48], [0.5, amplitude5]);
	osc0Limiter6 = Select.ar(feedback0[23], [feedback0GrainMacro6, osc0Decimate6]) * Select.kr(feedback0[48], [0.5, amplitude6]);
	osc0Limiter7 = Select.ar(feedback0[23], [feedback0GrainMacro7, osc0Decimate7]) * Select.kr(feedback0[48], [0.5, amplitude7]);
	osc0Limiter8 = Select.ar(feedback0[23], [feedback0GrainMacro8, osc0Decimate8]) * Select.kr(feedback0[48], [0.5, amplitude8]);
	osc0Limiter9 = Select.ar(feedback0[23], [feedback0GrainMacro9, osc0Decimate9]) * Select.kr(feedback0[48], [0.5, amplitude9]);
	osc0Limiter10 = Select.ar(feedback0[23], [feedback0GrainMacro10, osc0Decimate10]) * Select.kr(feedback0[48], [0.5, amplitude10]);
	osc0Limiter11 = Select.ar(feedback0[23], [feedback0GrainMacro11, osc0Decimate11]) * Select.kr(feedback0[48], [0.5, amplitude11]);
	osc0Limiter12 = Select.ar(feedback0[23], [feedback0GrainMacro12, osc0Decimate12]) * Select.kr(feedback0[48], [0.5, amplitude12]);

	grain2PitchArray0 = [pitchChooser0, pitchChooser1, pitchChooser2, pitchChooser3, pitchChooser4, pitchChooser5, pitchChooser6, pitchChooser7, pitchChooser8, pitchChooser9, pitchChooser10, pitchChooser11, pitchChooser12];

	onsetDuration2ArrayOut0 = [duration0, duration1, duration2, duration3, duration4, duration5, duration6, duration7, duration8, duration9, duration10, duration11, duration12].min(4);

	positionArray2 = [position0, position1, position2, position3, position4, position5, position6, position7, position8, position9, position10, position11, position12];

// Output granular synthesizers to audio bus
	Out.ar(~triggerOut2, LPF.ar([osc0Limiter0, osc0Limiter1, osc0Limiter2, osc0Limiter3, osc0Limiter4, osc0Limiter5, osc0Limiter6, osc0Limiter7, osc0Limiter8, osc0Limiter9, osc0Limiter10, osc0Limiter11, osc0Limiter12], 4000));

// Output fractal data to control bus
	Out.kr(~duration2Bus0, onsetDuration2ArrayOut0);

	Out.kr(~grainPositionBus2, positionArray2);

	Out.kr(~grainPitch2Bus0, grain2PitchArray0);

	Out.kr(~filterFreqBus2, [osc2Freq0, osc2Freq1, osc2Freq2, osc2Freq3, osc2Freq4, osc2Freq5, osc2Freq6, osc2Freq7, osc2Freq8, osc2Freq9, osc2Freq10, osc2Freq11, osc2Freq12]);

	}).send(s);

// Pitch Fixer synth

	SynthDef(\scaler, {

	arg bufnum, amount = 1, grainSize = 0.1, flatAdjust = 1.05, factor = 0;

	var index, in, inMix, out, freq, frequencyDiff, pitches, fixedFrequency, actualFrequency, freqAdjust, out2;

// Obtain slave sound-object audio bus
	in = InFeedback.ar(~scaleSend0, 1);
	freq = In.kr(~gui0Bus0, 63);

// Adjust MIDI to frequency class
	freqAdjust = ((freq[24].cpsmidi) + factor).midicps;

// collect scale
	index = IndexInBetween.kr(bufnum, freqAdjust);

// calculate difference between scale and slave
	frequencyDiff = index.frac * (Index.kr(bufnum, index + 1) - Index.kr(bufnum, index));

// adjust output realtive to correction
	out = PitchShift.ar(in, grainSize, 1 - (frequencyDiff / freqAdjust), 0.00001, 0.01) * 2;

	out2 = PitchShift.ar(out, grainSize, flatAdjust, 0.00001, 0.01) * 2;

	fixedFrequency = MeanTriggered.kr(Pitch.kr(out), Impulse.kr(20), 1);

	pitches = [freqAdjust, frequencyDiff, ((fixedFrequency.cpsmidi) + 1).midicps];

// send output to audio bus
	Out.ar(~scaleBusOut0, out2);

// send values to control bus for GUI
	Out.kr(~scaleControl0, pitches);

	}).send(s);


// Freeze and Pan granular synthesizers for onsets triggered by control one
	SynthDef(\panner0,{

	arg grain0panner0 = 0, grain0panner1 = 0, grain0panner2 = 0, grain0panner3 = 0, grain0panner4 = 0, grain0panner5 = 0, grain0panner6 = 0, grain0panner7 = 0, grain0panner8 = 0, grain0panner9 = 0, grain0panner10 = 0, grain0panner11 = 0, grain0panner12 = 0;

	var grain0Pan0, grain0Pan1, grain0Pan2, grain0Pan3, grain0Pan4, grain0Pan5, grain0Pan6, grain0Pan7, grain0Pan8, grain0Pan9, grain0Pan10, grain0Pan11, grain0Pan12, envelopes0, envelopes1, envelopes2, grain0RateArray0, feedback0, filterData0;

	var grain0PanArray0, grain1PanArray0, grain0Array0, grain1Array0, grain2Array0, triggersIn0, triggersIn1, triggersIn2, onset0Mix0, onset1Mix0, feedback0GrainMix0;

	var filter0Shift0, freezeArray0;

	var freezeOn0, freezeOn1, freezeOn2, freezeOn3, freezeOn4, freezeOn5, freezeOn6, freezeOn7, freezeOn8, freezeOn9, freezeOn10, freezeOn11, freezeOn12;

	var grain0Shift0, grain0Shift1, grain0Shift2, grain0Shift3, grain0Shift4, grain0Shift5, grain0Shift6, grain0Shift7, grain0Shift8, grain0Shift9, grain0Shift10, grain0Shift11, grain0Shift12, triggersMix;

	grain0PanArray0 = [grain0panner0, grain0panner1, grain0panner2, grain0panner3, grain0panner4, grain0panner5, grain0panner6, grain0panner7, grain0panner8, grain0panner9, grain0panner10, grain0panner11, grain0panner12];

// Obtain triggers from control bus for control one
	triggersIn0 = InFeedback.ar(~triggerOut0, 13);

// Obtain envelopes from control bus for control one
	envelopes0 = In.kr(~envelopeBus0, 13);

	feedback0 = In.kr(~gui0Bus0, 63);

// round freeze
	freezeOn0 = envelopes0[0].round(1);
	freezeOn1 = envelopes0[1].round(1);
	freezeOn2 = envelopes0[2].round(1);
	freezeOn3 = envelopes0[3].round(1);
	freezeOn4 = envelopes0[4].round(1);
	freezeOn5 = envelopes0[5].round(1);
	freezeOn6 = envelopes0[6].round(1);
	freezeOn7 = envelopes0[7].round(1);
	freezeOn8 = envelopes0[8].round(1);
	freezeOn9 = envelopes0[9].round(1);
	freezeOn10 = envelopes0[10].round(1);
	freezeOn11 = envelopes0[11].round(1);
	freezeOn12 = envelopes0[12].round(1);

// freeze each granular synthesizer
	grain0Shift0 = FFT(~pitchBuffer0[0], triggersIn0[0]);
	grain0Shift0 = PV_Freeze(grain0Shift0, freezeOn0);
	grain0Pan0 = Pan2.ar(IFFT(grain0Shift0), grain0PanArray0[0], 1) * envelopes0[0];

	grain0Shift1 = FFT(~pitchBuffer0[1], triggersIn0[1]);
	grain0Shift1 = PV_Freeze(grain0Shift1, freezeOn1);
	grain0Pan1 = Pan2.ar(IFFT(grain0Shift1), grain0PanArray0[1], 1) * envelopes0[1];

	grain0Shift2 = FFT(~pitchBuffer0[2], triggersIn0[2]);
	grain0Shift2 = PV_Freeze(grain0Shift2, freezeOn2);
	grain0Pan2 = Pan2.ar(IFFT(grain0Shift2), grain0PanArray0[2], 1) * envelopes0[2];

	grain0Shift3 = FFT(~pitchBuffer0[3], triggersIn0[3]);
	grain0Shift3 = PV_Freeze(grain0Shift3, freezeOn3);
	grain0Pan3 = Pan2.ar(IFFT(grain0Shift3), grain0PanArray0[3], 1) * envelopes0[3];

	grain0Shift4 = FFT(~pitchBuffer0[4], triggersIn0[4]);
	grain0Shift4 = PV_Freeze(grain0Shift4, freezeOn4);
	grain0Pan4 = Pan2.ar(IFFT(grain0Shift4), grain0PanArray0[4], 1) * envelopes0[4];

	grain0Shift5 = FFT(~pitchBuffer0[5], triggersIn0[5]);
	grain0Shift5 = PV_Freeze(grain0Shift5, freezeOn5);
	grain0Pan5 = Pan2.ar(IFFT(grain0Shift5), grain0PanArray0[5], 1) * envelopes0[5];

	grain0Shift6 = FFT(~pitchBuffer0[6], triggersIn0[6]);
	grain0Shift6 = PV_Freeze(grain0Shift6, freezeOn6);
	grain0Pan6 = Pan2.ar(IFFT(grain0Shift6), grain0PanArray0[6], 1) * envelopes0[6];

	grain0Shift7 = FFT(~pitchBuffer0[7], triggersIn0[7]);
	grain0Shift7 = PV_Freeze(grain0Shift7, freezeOn7);
	grain0Pan7 = Pan2.ar(IFFT(grain0Shift7), grain0PanArray0[7], 1) * envelopes0[7];

	grain0Shift8 = FFT(~pitchBuffer0[8], triggersIn0[8]);
	grain0Shift8 = PV_Freeze(grain0Shift8, freezeOn8);
	grain0Pan8 = Pan2.ar(IFFT(grain0Shift8), grain0PanArray0[8], 1) * envelopes0[8];

	grain0Shift9 = FFT(~pitchBuffer0[9], triggersIn0[9]);
	grain0Shift9 = PV_Freeze(grain0Shift9, freezeOn9);
	grain0Pan9 = Pan2.ar(IFFT(grain0Shift9), grain0PanArray0[9], 1) * envelopes0[9];

	grain0Shift10 = FFT(~pitchBuffer0[10], triggersIn0[10]);
	grain0Shift10 = PV_Freeze(grain0Shift10, freezeOn10);
	grain0Pan10 = Pan2.ar(IFFT(grain0Shift10), grain0PanArray0[10], 1) * envelopes0[10];

	grain0Shift11 = FFT(~pitchBuffer0[11], triggersIn0[11]);
	grain0Shift11 = PV_Freeze(grain0Shift11, freezeOn11);
	grain0Pan11 = Pan2.ar(IFFT(grain0Shift11), grain0PanArray0[11], 1) * envelopes0[11];

	grain0Shift12 = FFT(~pitchBuffer0[12], triggersIn0[12]);
	grain0Shift12 = PV_Freeze(grain0Shift12, freezeOn12);
	grain0Pan12 = Pan2.ar(IFFT(grain0Shift12), grain0PanArray0[12], 1) * envelopes0[12];

	onset0Mix0 = grain0Pan0 + grain0Pan1 + grain0Pan2 + grain0Pan3 + grain0Pan4 + grain0Pan5 + grain0Pan6 + grain0Pan7 + grain0Pan8 + grain0Pan9 + grain0Pan10 + grain0Pan11 + grain0Pan12;

	freezeArray0 = [freezeOn0, freezeOn1, freezeOn2, freezeOn3, freezeOn4, freezeOn5, freezeOn6, freezeOn7, freezeOn8, freezeOn9, freezeOn10, freezeOn11, freezeOn12];

// Pan each granular synthesizer
	triggersMix = (
	Pan2.ar(triggersIn0[0], grain0PanArray0[0]) +
	Pan2.ar(triggersIn0[1], grain0PanArray0[1]) +
	Pan2.ar(triggersIn0[2], grain0PanArray0[2]) +
	Pan2.ar(triggersIn0[3], grain0PanArray0[3]) +
	Pan2.ar(triggersIn0[4], grain0PanArray0[4]) +
	Pan2.ar(triggersIn0[5], grain0PanArray0[5]) +
	Pan2.ar(triggersIn0[6], grain0PanArray0[6]) +
	Pan2.ar(triggersIn0[7], grain0PanArray0[7]) +
	Pan2.ar(triggersIn0[8], grain0PanArray0[8]) +
	Pan2.ar(triggersIn0[9], grain0PanArray0[9]) +
	Pan2.ar(triggersIn0[10], grain0PanArray0[10]) +
	Pan2.ar(triggersIn0[11], grain0PanArray0[11]) +
	Pan2.ar(triggersIn0[12], grain0PanArray0[12]));

// send output to audio bus
	Out.ar(~grain0Bus0, (Pan2.ar(((onset0Mix0 * feedback0[31]) + (triggersMix * feedback0[34])), 0, 1)));

// send freeze and pan values to control bus
	Out.kr(~pan0Bus0, grain0PanArray0);
	Out.kr(~freezeBus0, freezeArray0);

	}).send(s);

// Freeze and Pan granular synthesizers for onsets triggered by control two
	SynthDef(\panner1,{

	arg grain1panner0 = 0, grain1panner1 = 0, grain1panner2 = 0, grain1panner3 = 0, grain1panner4 = 0, grain1panner5 = 0, grain1panner6 = 0, grain1panner7 = 0, grain1panner8 = 0, grain1panner9 = 0, grain1panner10 = 0, grain1panner11 = 0, grain1panner12 = 0;

	var envelopes0, envelopes1, envelopes2, triggersMix, freezeArray1;

	var grain1Pan0, grain1Pan1, grain1Pan2, grain1Pan3, grain1Pan4, grain1Pan5, grain1Pan6, grain1Pan7, grain1Pan8, grain1Pan9, grain1Pan10, grain1Pan11, grain1Pan12;
	var freezeOn0, freezeOn1, freezeOn2, freezeOn3, freezeOn4, freezeOn5, freezeOn6, freezeOn7, freezeOn8, freezeOn9, freezeOn10, freezeOn11, freezeOn12;

	var grain1Shift0, grain1Shift1, grain1Shift2, grain1Shift3, grain1Shift4, grain1Shift5, grain1Shift6, grain1Shift7, grain1Shift8, grain1Shift9, grain1Shift10, grain1Shift11, grain1Shift12;

	var grain0PanArray0, grain1PanArray0, grain0Array0, grain1Array0, grain2Array0, triggersIn0, triggersIn1, triggersIn2, onset0Mix0, onset1Mix0, feedback0GrainMix0;

	var filterData0, filterData1, filterData2, feedback0, grain0RateArray0, grain1RateArray0;

	grain1PanArray0 = [grain1panner0, grain1panner1, grain1panner2, grain1panner3, grain1panner4, grain1panner5, grain1panner6, grain1panner7, grain1panner8, grain1panner9, grain1panner10, grain1panner11, grain1panner12];

// Obtain triggers from control bus for control two
	triggersIn1 = InFeedback.ar(~triggerOut1, 13);

// Obtain envelopes from control bus for control two
	envelopes1 = In.kr(~envelopeBus1, 13);

	feedback0 = In.kr(~gui0Bus0, 63);

// round freeze
	freezeOn0 = envelopes1[0].round(1);
	freezeOn1 = envelopes1[1].round(1);
	freezeOn2 = envelopes1[2].round(1);
	freezeOn3 = envelopes1[3].round(1);
	freezeOn4 = envelopes1[4].round(1);
	freezeOn5 = envelopes1[5].round(1);
	freezeOn6 = envelopes1[6].round(1);
	freezeOn7 = envelopes1[7].round(1);
	freezeOn8 = envelopes1[8].round(1);
	freezeOn9 = envelopes1[9].round(1);
	freezeOn10 = envelopes1[10].round(1);
	freezeOn11 = envelopes1[11].round(1);
	freezeOn12 = envelopes1[12].round(1);

// freeze each granular synthesizer
	grain1Shift0 = FFT(~pitchBuffer0[13], triggersIn1[0]);
	grain1Shift0 = PV_Freeze(grain1Shift0, freezeOn0);
	grain1Pan0 = Pan2.ar(IFFT(grain1Shift0), grain1PanArray0[0], 1) * envelopes1[0];

	grain1Shift1 = FFT(~pitchBuffer0[14], triggersIn1[1]);
	grain1Shift1 = PV_Freeze(grain1Shift1, freezeOn1);
	grain1Pan1 = Pan2.ar(IFFT(grain1Shift1), grain1PanArray0[1], 1) * envelopes1[1];

	grain1Shift2 = FFT(~pitchBuffer0[15], triggersIn1[2]);
	grain1Shift2 = PV_Freeze(grain1Shift2, freezeOn2);
	grain1Pan2 = Pan2.ar(IFFT(grain1Shift2), grain1PanArray0[2], 1) * envelopes1[2];

	grain1Shift3 = FFT(~pitchBuffer0[16], triggersIn1[3]);
	grain1Shift3 = PV_Freeze(grain1Shift3, freezeOn3);
	grain1Pan3 = Pan2.ar(IFFT(grain1Shift3), grain1PanArray0[3], 1) * envelopes1[3];

	grain1Shift4 = FFT(~pitchBuffer0[17], triggersIn1[4]);
	grain1Shift4 = PV_Freeze(grain1Shift4, freezeOn4);
	grain1Pan4 = Pan2.ar(IFFT(grain1Shift4), grain1PanArray0[4], 1) * envelopes1[4];

	grain1Shift5 = FFT(~pitchBuffer0[18], triggersIn1[5]);
	grain1Shift5 = PV_Freeze(grain1Shift5, freezeOn5);
	grain1Pan5 = Pan2.ar(IFFT(grain1Shift5), grain1PanArray0[5], 1) * envelopes1[5];

	grain1Shift6 = FFT(~pitchBuffer0[19], triggersIn1[6]);
	grain1Shift6 = PV_Freeze(grain1Shift6, freezeOn6);
	grain1Pan6 = Pan2.ar(IFFT(grain1Shift6), grain1PanArray0[6], 1) * envelopes1[6];

	grain1Shift7 = FFT(~pitchBuffer0[20], triggersIn1[7]);
	grain1Shift7 = PV_Freeze(grain1Shift7, freezeOn7);
	grain1Pan7 = Pan2.ar(IFFT(grain1Shift7), grain1PanArray0[7], 1) * envelopes1[7];

	grain1Shift8 = FFT(~pitchBuffer0[21], triggersIn1[8]);
	grain1Shift8 = PV_Freeze(grain1Shift8, freezeOn8);
	grain1Pan8 = Pan2.ar(IFFT(grain1Shift8), grain1PanArray0[8], 1) * envelopes1[8];

	grain1Shift9 = FFT(~pitchBuffer0[22], triggersIn1[9]);
	grain1Shift9 = PV_Freeze(grain1Shift9, freezeOn9);
	grain1Pan9 = Pan2.ar(IFFT(grain1Shift9), grain1PanArray0[9], 1) * envelopes1[9];

	grain1Shift10 = FFT(~pitchBuffer0[23], triggersIn1[10]);
	grain1Shift10 = PV_Freeze(grain1Shift10, freezeOn10);
	grain1Pan10 = Pan2.ar(IFFT(grain1Shift10), grain1PanArray0[10], 1) * envelopes1[10];

	grain1Shift11 = FFT(~pitchBuffer0[24], triggersIn1[11]);
	grain1Shift11 = PV_Freeze(grain1Shift11, freezeOn11);
	grain1Pan11 = Pan2.ar(IFFT(grain1Shift11), grain1PanArray0[11], 1) * envelopes1[11];

	grain1Shift12 = FFT(~pitchBuffer0[25], triggersIn1[12]);
	grain1Shift12 = PV_Freeze(grain1Shift12, freezeOn12);
	grain1Pan12 = Pan2.ar(IFFT(grain1Shift12), grain1PanArray0[12], 1) * envelopes1[12];

	onset1Mix0 = grain1Pan0 + grain1Pan1 + grain1Pan2 + grain1Pan3 + grain1Pan4 + grain1Pan5 + grain1Pan6 + grain1Pan7 + grain1Pan8 + grain1Pan9 + grain1Pan10 + grain1Pan11 + grain1Pan12;

	freezeArray1 = [freezeOn0, freezeOn1, freezeOn2, freezeOn3, freezeOn4, freezeOn5, freezeOn6, freezeOn7, freezeOn8, freezeOn9, freezeOn10, freezeOn11, freezeOn12];

// Pan each granular synthesizer
	triggersMix = (
	Pan2.ar(triggersIn1[0], grain1PanArray0[0]) +
	Pan2.ar(triggersIn1[1], grain1PanArray0[1]) +
	Pan2.ar(triggersIn1[2], grain1PanArray0[2]) +
	Pan2.ar(triggersIn1[3], grain1PanArray0[3]) +
	Pan2.ar(triggersIn1[4], grain1PanArray0[4]) +
	Pan2.ar(triggersIn1[5], grain1PanArray0[5]) +
	Pan2.ar(triggersIn1[6], grain1PanArray0[6]) +
	Pan2.ar(triggersIn1[7], grain1PanArray0[7]) +
	Pan2.ar(triggersIn1[8], grain1PanArray0[8]) +
	Pan2.ar(triggersIn1[9], grain1PanArray0[9]) +
	Pan2.ar(triggersIn1[10], grain1PanArray0[10]) +
	Pan2.ar(triggersIn1[11], grain1PanArray0[11]) +
	Pan2.ar(triggersIn1[12], grain1PanArray0[12]));

// send output to audio bus
	Out.ar(~grain1Bus0, (Pan2.ar(((onset1Mix0 * feedback0[32]) + (triggersMix * feedback0[35])), 0, 1)));

// send freeze and pan values to control bus
	Out.kr(~pan1Bus0, grain1PanArray0);
	Out.kr(~freezeBus1, freezeArray1);

	}).send(s);

// Freeze and Pan granular synthesizers for onsets triggered by control three/slave
	SynthDef(\panner2,{

	arg grain2PanArray0 = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	var grain2Pan0, grain2Pan1, grain2Pan2, grain2Pan3, grain2Pan4, grain2Pan5, grain2Pan6, grain2Pan7, grain2Pan8, grain2Pan9, grain2Pan10, grain2Pan11, grain2Pan12, envelopes2, triggersMix, freezeArray2;

	var grain0PanArray0, grain1PanArray0, grain0Array0, grain1Array0, grain2Array0, triggersIn0, triggersIn1, triggersIn2, onset0Mix0, onset1Mix0, feedback0GrainMix0;

	var freezeOn0, freezeOn1, freezeOn2, freezeOn3, freezeOn4, freezeOn5, freezeOn6, freezeOn7, freezeOn8, freezeOn9, freezeOn10, freezeOn11, freezeOn12;

	var grain2Shift0, grain2Shift1, grain2Shift2, grain2Shift3, grain2Shift4, grain2Shift5, grain2Shift6, grain2Shift7, grain2Shift8, grain2Shift9, grain2Shift10, grain2Shift11, grain2Shift12, filterData0, filterData1, filterData2, feedback0, grain0RateArray0, grain1RateArray0;

// Obtain triggers from control bus for control three
	triggersIn2 = InFeedback.ar(~triggerOut2, 13);

// Obtain envelopes from control bus for control three
	envelopes2 = In.kr(~envelopeBus2, 13);

	feedback0 = In.kr(~gui0Bus0, 63);

// round freeze
	freezeOn0 = envelopes2[0].round(1);
	freezeOn1 = envelopes2[1].round(1);
	freezeOn2 = envelopes2[2].round(1);
	freezeOn3 = envelopes2[3].round(1);
	freezeOn4 = envelopes2[4].round(1);
	freezeOn5 = envelopes2[5].round(1);
	freezeOn6 = envelopes2[6].round(1);
	freezeOn7 = envelopes2[7].round(1);
	freezeOn8 = envelopes2[8].round(1);
	freezeOn9 = envelopes2[9].round(1);
	freezeOn10 = envelopes2[10].round(1);
	freezeOn11 = envelopes2[11].round(1);
	freezeOn12 = envelopes2[12].round(1);

// freeze each granular synthesizer
	grain2Shift0 = FFT(~pitchBuffer0[26], triggersIn2[0]);
	grain2Shift0 = PV_Freeze(grain2Shift0, freezeOn0);
	grain2Pan0 = Pan2.ar(IFFT(grain2Shift0), grain2PanArray0[0], 1) * envelopes2[0];

	grain2Shift1 = FFT(~pitchBuffer0[27], triggersIn2[1]);
	grain2Shift1 = PV_Freeze(grain2Shift1, freezeOn1);
	grain2Pan1 = Pan2.ar(IFFT(grain2Shift1), grain2PanArray0[1], 1) * envelopes2[1];

	grain2Shift2 = FFT(~pitchBuffer0[28], triggersIn2[2]);
	grain2Shift2 = PV_Freeze(grain2Shift2, freezeOn2);
	grain2Pan2 = Pan2.ar(IFFT(grain2Shift2), grain2PanArray0[2], 1) * envelopes2[2];

	grain2Shift3 = FFT(~pitchBuffer0[29], triggersIn2[3]);
	grain2Shift3 = PV_Freeze(grain2Shift3, freezeOn3);
	grain2Pan3 = Pan2.ar(IFFT(grain2Shift3), grain2PanArray0[3], 1) * envelopes2[3];

	grain2Shift4 = FFT(~pitchBuffer0[30], triggersIn2[4]);
	grain2Shift4 = PV_Freeze(grain2Shift4, freezeOn4);
	grain2Pan4 = Pan2.ar(IFFT(grain2Shift4), grain2PanArray0[4], 1) * envelopes2[4];

	grain2Shift5 = FFT(~pitchBuffer0[31], triggersIn2[5]);
	grain2Shift5 = PV_Freeze(grain2Shift5, freezeOn5);
	grain2Pan5 = Pan2.ar(IFFT(grain2Shift5), grain2PanArray0[5], 1) * envelopes2[5];

	grain2Shift6 = FFT(~pitchBuffer0[32], triggersIn2[6]);
	grain2Shift6 = PV_Freeze(grain2Shift6, freezeOn6);
	grain2Pan6 = Pan2.ar(IFFT(grain2Shift6), grain2PanArray0[6], 1) * envelopes2[6];

	grain2Shift7 = FFT(~pitchBuffer0[33], triggersIn2[7]);
	grain2Shift7 = PV_Freeze(grain2Shift7, freezeOn7);
	grain2Pan7 = Pan2.ar(IFFT(grain2Shift7), grain2PanArray0[7], 1) * envelopes2[7];

	grain2Shift8 = FFT(~pitchBuffer0[34], triggersIn2[8]);
	grain2Shift8 = PV_Freeze(grain2Shift8, freezeOn8);
	grain2Pan8 = Pan2.ar(IFFT(grain2Shift8), grain2PanArray0[8], 1) * envelopes2[8];

	grain2Shift9 = FFT(~pitchBuffer0[35], triggersIn2[9]);
	grain2Shift9 = PV_Freeze(grain2Shift9, freezeOn9);
	grain2Pan9 = Pan2.ar(IFFT(grain2Shift9), grain2PanArray0[9], 1) * envelopes2[9];

	grain2Shift10 = FFT(~pitchBuffer0[36], triggersIn2[10]);
	grain2Shift10 = PV_Freeze(grain2Shift10, freezeOn10);
	grain2Pan10 = Pan2.ar(IFFT(grain2Shift10), grain2PanArray0[10], 1) * envelopes2[10];

	grain2Shift11 = FFT(~pitchBuffer0[37], triggersIn2[11]);
	grain2Shift11 = PV_Freeze(grain2Shift11, freezeOn11);
	grain2Pan11 = Pan2.ar(IFFT(grain2Shift11), grain2PanArray0[11], 1) * envelopes2[11];

	grain2Shift12 = FFT(~pitchBuffer0[38], triggersIn2[12]);
	grain2Shift12 = PV_Freeze(grain2Shift12, freezeOn12);
	grain2Pan12 = Pan2.ar(IFFT(grain2Shift12), grain2PanArray0[12], 1) * envelopes2[12];

	feedback0GrainMix0 = grain2Pan0 + grain2Pan1 + grain2Pan2 + grain2Pan3 + grain2Pan4 + grain2Pan5 + grain2Pan6 + grain2Pan7 + grain2Pan8 + grain2Pan9 + grain2Pan10 + grain2Pan11 + grain2Pan12;

	freezeArray2 = [freezeOn0, freezeOn1, freezeOn2, freezeOn3, freezeOn4, freezeOn5, freezeOn6, freezeOn7, freezeOn8, freezeOn9, freezeOn10, freezeOn11, freezeOn12];

// Pan each granular synthesizer
	triggersMix = (
	Pan2.ar(triggersIn2[0], grain2PanArray0[0]) +
	Pan2.ar(triggersIn2[1], grain2PanArray0[1]) +
	Pan2.ar(triggersIn2[2], grain2PanArray0[2]) +
	Pan2.ar(triggersIn2[3], grain2PanArray0[3]) +
	Pan2.ar(triggersIn2[4], grain2PanArray0[4]) +
	Pan2.ar(triggersIn2[5], grain2PanArray0[5]) +
	Pan2.ar(triggersIn2[6], grain2PanArray0[6]) +
	Pan2.ar(triggersIn2[7], grain2PanArray0[7]) +
	Pan2.ar(triggersIn2[8], grain2PanArray0[8]) +
	Pan2.ar(triggersIn2[9], grain2PanArray0[9]) +
	Pan2.ar(triggersIn2[10], grain2PanArray0[10]) +
	Pan2.ar(triggersIn2[11], grain2PanArray0[11]) +
	Pan2.ar(triggersIn2[12], grain2PanArray0[12]));

// send output to audio bus
	Out.ar(~grain2Bus0, (Pan2.ar(((feedback0GrainMix0 * feedback0[33]) + (triggersMix * feedback0[36])), 0, 1)));

// send freeze and pan values to control bus
	Out.kr(~pan2Bus0, grain2PanArray0);
	Out.kr(~freezeBus2, freezeArray2);

	}).send(s);

// Pan process for lo performance CPUs for control one (removal of Freeze process)
	SynthDef(\pannerLo0,{

	arg grain0panner0 = 0, grain0panner1 = 0, grain0panner2 = 0, grain0panner3 = 0, grain0panner4 = 0, grain0panner5 = 0, grain0panner6 = 0, grain0panner7 = 0, grain0panner8 = 0, grain0panner9 = 0, grain0panner10 = 0, grain0panner11 = 0, grain0panner12 = 0;

	var grain0Pan0, grain0Pan1, grain0Pan2, grain0Pan3, grain0Pan4, grain0Pan5, grain0Pan6, grain0Pan7, grain0Pan8, grain0Pan9, grain0Pan10, grain0Pan11, grain0Pan12, envelopes0, envelopes1, envelopes2, grain0RateArray0, feedback0, filterData0;

	var grain0PanArray0, grain1PanArray0, grain0Array0, grain1Array0, grain2Array0, triggersIn0, triggersIn1, triggersIn2, onset0Mix0, onset1Mix0, feedback0GrainMix0;

	var filter0Shift0, freezeArray0;

	var freezeOn0, freezeOn1, freezeOn2, freezeOn3, freezeOn4, freezeOn5, freezeOn6, freezeOn7, freezeOn8, freezeOn9, freezeOn10, freezeOn11, freezeOn12;

	var grain0Shift0, grain0Shift1, grain0Shift2, grain0Shift3, grain0Shift4, grain0Shift5, grain0Shift6, grain0Shift7, grain0Shift8, grain0Shift9, grain0Shift10, grain0Shift11, grain0Shift12, triggersMix;

	grain0PanArray0 = [grain0panner0, grain0panner1, grain0panner2, grain0panner3, grain0panner4, grain0panner5, grain0panner6, grain0panner7, grain0panner8, grain0panner9, grain0panner10, grain0panner11, grain0panner12];

// Obtain triggers from control bus for control one
	triggersIn0 = InFeedback.ar(~triggerOut0, 13);

// Obtain envelopes from control bus for control one
	envelopes0 = In.kr(~envelopeBus0, 13);

	feedback0 = In.kr(~gui0Bus0, 63);

// round freeze
	freezeOn0 = envelopes0[0].round(1);
	freezeOn1 = envelopes0[1].round(1);
	freezeOn2 = envelopes0[2].round(1);
	freezeOn3 = envelopes0[3].round(1);
	freezeOn4 = envelopes0[4].round(1);
	freezeOn5 = envelopes0[5].round(1);
	freezeOn6 = envelopes0[6].round(1);
	freezeOn7 = envelopes0[7].round(1);
	freezeOn8 = envelopes0[8].round(1);
	freezeOn9 = envelopes0[9].round(1);
	freezeOn10 = envelopes0[10].round(1);
	freezeOn11 = envelopes0[11].round(1);
	freezeOn12 = envelopes0[12].round(1);

// Pan each granular synthesizer
	grain0Pan0 = Pan2.ar(triggersIn0[0], grain0PanArray0[0], 1) * envelopes0[0];
	grain0Pan1 = Pan2.ar(triggersIn0[1], grain0PanArray0[1], 1) * envelopes0[1];
	grain0Pan2 = Pan2.ar(triggersIn0[2], grain0PanArray0[2], 1) * envelopes0[2];
	grain0Pan3 = Pan2.ar(triggersIn0[3], grain0PanArray0[3], 1) * envelopes0[3];
	grain0Pan4 = Pan2.ar(triggersIn0[4], grain0PanArray0[4], 1) * envelopes0[4];
	grain0Pan5 = Pan2.ar(triggersIn0[5], grain0PanArray0[5], 1) * envelopes0[5];
	grain0Pan6 = Pan2.ar(triggersIn0[6], grain0PanArray0[6], 1) * envelopes0[6];
	grain0Pan7 = Pan2.ar(triggersIn0[7], grain0PanArray0[7], 1) * envelopes0[7];
	grain0Pan8 = Pan2.ar(triggersIn0[8], grain0PanArray0[8], 1) * envelopes0[8];
	grain0Pan9 = Pan2.ar(triggersIn0[9], grain0PanArray0[9], 1) * envelopes0[9];
	grain0Pan10 = Pan2.ar(triggersIn0[10], grain0PanArray0[10], 1) * envelopes0[10];
	grain0Pan11 = Pan2.ar(triggersIn0[11], grain0PanArray0[11], 1) * envelopes0[11];
	grain0Pan12 = Pan2.ar(triggersIn0[12], grain0PanArray0[12], 1) * envelopes0[12];

	onset0Mix0 = grain0Pan0 + grain0Pan1 + grain0Pan2 + grain0Pan3 + grain0Pan4 + grain0Pan5 + grain0Pan6 + grain0Pan7 + grain0Pan8 + grain0Pan9 + grain0Pan10 + grain0Pan11 + grain0Pan12;

	freezeArray0 = [freezeOn0, freezeOn1, freezeOn2, freezeOn3, freezeOn4, freezeOn5, freezeOn6, freezeOn7, freezeOn8, freezeOn9, freezeOn10, freezeOn11, freezeOn12];

	triggersMix = (
	Pan2.ar(triggersIn0[0], grain0PanArray0[0]) +
	Pan2.ar(triggersIn0[1], grain0PanArray0[1]) +
	Pan2.ar(triggersIn0[2], grain0PanArray0[2]) +
	Pan2.ar(triggersIn0[3], grain0PanArray0[3]) +
	Pan2.ar(triggersIn0[4], grain0PanArray0[4]) +
	Pan2.ar(triggersIn0[5], grain0PanArray0[5]) +
	Pan2.ar(triggersIn0[6], grain0PanArray0[6]) +
	Pan2.ar(triggersIn0[7], grain0PanArray0[7]) +
	Pan2.ar(triggersIn0[8], grain0PanArray0[8]) +
	Pan2.ar(triggersIn0[9], grain0PanArray0[9]) +
	Pan2.ar(triggersIn0[10], grain0PanArray0[10]) +
	Pan2.ar(triggersIn0[11], grain0PanArray0[11]) +
	Pan2.ar(triggersIn0[12], grain0PanArray0[12]));

// send outputs to audio bus
	Out.ar(~grain0Bus0, (Pan2.ar(((onset0Mix0 * feedback0[31]) + (triggersMix * feedback0[34])), 0, 1)));

// send pan values to control bus
	Out.kr(~pan0Bus0, grain0PanArray0);
	Out.kr(~freezeBus0, freezeArray0);

	}).send(s);

// Pan process for lo performance CPUs for control two (removal of Freeze process)
	SynthDef(\pannerLo1,{

	arg grain1panner0 = 0, grain1panner1 = 0, grain1panner2 = 0, grain1panner3 = 0, grain1panner4 = 0, grain1panner5 = 0, grain1panner6 = 0, grain1panner7 = 0, grain1panner8 = 0, grain1panner9 = 0, grain1panner10 = 0, grain1panner11 = 0, grain1panner12 = 0;

	var envelopes0, envelopes1, envelopes2, triggersMix, freezeArray1;

	var grain1Pan0, grain1Pan1, grain1Pan2, grain1Pan3, grain1Pan4, grain1Pan5, grain1Pan6, grain1Pan7, grain1Pan8, grain1Pan9, grain1Pan10, grain1Pan11, grain1Pan12;
	var freezeOn0, freezeOn1, freezeOn2, freezeOn3, freezeOn4, freezeOn5, freezeOn6, freezeOn7, freezeOn8, freezeOn9, freezeOn10, freezeOn11, freezeOn12;

	var grain1Shift0, grain1Shift1, grain1Shift2, grain1Shift3, grain1Shift4, grain1Shift5, grain1Shift6, grain1Shift7, grain1Shift8, grain1Shift9, grain1Shift10, grain1Shift11, grain1Shift12;

	var grain0PanArray0, grain1PanArray0, grain0Array0, grain1Array0, grain2Array0, triggersIn0, triggersIn1, triggersIn2, onset0Mix0, onset1Mix0, feedback0GrainMix0;

	var filterData0, filterData1, filterData2, feedback0, grain0RateArray0, grain1RateArray0;

	grain1PanArray0 = [grain1panner0, grain1panner1, grain1panner2, grain1panner3, grain1panner4, grain1panner5, grain1panner6, grain1panner7, grain1panner8, grain1panner9, grain1panner10, grain1panner11, grain1panner12];

// Obtain triggers from control bus for control two
	triggersIn1 = InFeedback.ar(~triggerOut1, 13);

// Obtain envelopes from control bus for control two
	envelopes1 = In.kr(~envelopeBus1, 13);

	feedback0 = In.kr(~gui0Bus0, 63);

// round freeze
	freezeOn0 = envelopes1[0].round(1);
	freezeOn1 = envelopes1[1].round(1);
	freezeOn2 = envelopes1[2].round(1);
	freezeOn3 = envelopes1[3].round(1);
	freezeOn4 = envelopes1[4].round(1);
	freezeOn5 = envelopes1[5].round(1);
	freezeOn6 = envelopes1[6].round(1);
	freezeOn7 = envelopes1[7].round(1);
	freezeOn8 = envelopes1[8].round(1);
	freezeOn9 = envelopes1[9].round(1);
	freezeOn10 = envelopes1[10].round(1);
	freezeOn11 = envelopes1[11].round(1);
	freezeOn12 = envelopes1[12].round(1);

// Pan each granular synthesizer
	grain1Pan0 = Pan2.ar(triggersIn1[0], grain1PanArray0[0], 1) * envelopes1[0];
	grain1Pan1 = Pan2.ar(triggersIn1[1], grain1PanArray0[1], 1) * envelopes1[1];
	grain1Pan2 = Pan2.ar(triggersIn1[2], grain1PanArray0[2], 1) * envelopes1[2];
	grain1Pan3 = Pan2.ar(triggersIn1[3], grain1PanArray0[3], 1) * envelopes1[3];
	grain1Pan4 = Pan2.ar(triggersIn1[4], grain1PanArray0[4], 1) * envelopes1[4];
	grain1Pan5 = Pan2.ar(triggersIn1[5], grain1PanArray0[5], 1) * envelopes1[5];
	grain1Pan6 = Pan2.ar(triggersIn1[6], grain1PanArray0[6], 1) * envelopes1[6];
	grain1Pan7 = Pan2.ar(triggersIn1[7], grain1PanArray0[7], 1) * envelopes1[7];
	grain1Pan8 = Pan2.ar(triggersIn1[8], grain1PanArray0[8], 1) * envelopes1[8];
	grain1Pan9 = Pan2.ar(triggersIn1[9], grain1PanArray0[9], 1) * envelopes1[9];
	grain1Pan10 = Pan2.ar(triggersIn1[10], grain1PanArray0[10], 1) * envelopes1[10];
	grain1Pan11 = Pan2.ar(triggersIn1[11], grain1PanArray0[11], 1) * envelopes1[11];
	grain1Pan12 = Pan2.ar(triggersIn1[12], grain1PanArray0[12], 1) * envelopes1[12];


	onset1Mix0 = grain1Pan0 + grain1Pan1 + grain1Pan2 + grain1Pan3 + grain1Pan4 + grain1Pan5 + grain1Pan6 + grain1Pan7 + grain1Pan8 + grain1Pan9 + grain1Pan10 + grain1Pan11 + grain1Pan12;

	freezeArray1 = [freezeOn0, freezeOn1, freezeOn2, freezeOn3, freezeOn4, freezeOn5, freezeOn6, freezeOn7, freezeOn8, freezeOn9, freezeOn10, freezeOn11, freezeOn12];

	triggersMix = (
	Pan2.ar(triggersIn1[0], grain1PanArray0[0]) +
	Pan2.ar(triggersIn1[1], grain1PanArray0[1]) +
	Pan2.ar(triggersIn1[2], grain1PanArray0[2]) +
	Pan2.ar(triggersIn1[3], grain1PanArray0[3]) +
	Pan2.ar(triggersIn1[4], grain1PanArray0[4]) +
	Pan2.ar(triggersIn1[5], grain1PanArray0[5]) +
	Pan2.ar(triggersIn1[6], grain1PanArray0[6]) +
	Pan2.ar(triggersIn1[7], grain1PanArray0[7]) +
	Pan2.ar(triggersIn1[8], grain1PanArray0[8]) +
	Pan2.ar(triggersIn1[9], grain1PanArray0[9]) +
	Pan2.ar(triggersIn1[10], grain1PanArray0[10]) +
	Pan2.ar(triggersIn1[11], grain1PanArray0[11]) +
	Pan2.ar(triggersIn1[12], grain1PanArray0[12]));

// send outputs to audio bus
	Out.ar(~grain1Bus0, (Pan2.ar(((onset1Mix0 * feedback0[32]) + (triggersMix * feedback0[35])), 0, 1)));

// send pan values to control bus
	Out.kr(~pan1Bus0, grain1PanArray0);
	Out.kr(~freezeBus1, freezeArray1);

	}).send(s);

// Pan process for lo performance CPUs for control three/slave (removal of Freeze process)
	SynthDef(\pannerLo2,{

	arg grain2PanArray0 = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	var grain2Pan0, grain2Pan1, grain2Pan2, grain2Pan3, grain2Pan4, grain2Pan5, grain2Pan6, grain2Pan7, grain2Pan8, grain2Pan9, grain2Pan10, grain2Pan11, grain2Pan12, envelopes2, triggersMix, freezeArray2;

	var grain0PanArray0, grain1PanArray0, grain0Array0, grain1Array0, grain2Array0, triggersIn0, triggersIn1, triggersIn2, onset0Mix0, onset1Mix0, feedback0GrainMix0;

	var freezeOn0, freezeOn1, freezeOn2, freezeOn3, freezeOn4, freezeOn5, freezeOn6, freezeOn7, freezeOn8, freezeOn9, freezeOn10, freezeOn11, freezeOn12;

	var grain2Shift0, grain2Shift1, grain2Shift2, grain2Shift3, grain2Shift4, grain2Shift5, grain2Shift6, grain2Shift7, grain2Shift8, grain2Shift9, grain2Shift10, grain2Shift11, grain2Shift12, filterData0, filterData1, filterData2, feedback0, grain0RateArray0, grain1RateArray0;

// Obtain triggers from control bus for control three
	triggersIn2 = InFeedback.ar(~triggerOut2, 13);

// Obtain envelopes from control bus for control three
	envelopes2 = In.kr(~envelopeBus2, 13);

	feedback0 = In.kr(~gui0Bus0, 63);

// round freeze
	freezeOn0 = envelopes2[0].round(1);
	freezeOn1 = envelopes2[1].round(1);
	freezeOn2 = envelopes2[2].round(1);
	freezeOn3 = envelopes2[3].round(1);
	freezeOn4 = envelopes2[4].round(1);
	freezeOn5 = envelopes2[5].round(1);
	freezeOn6 = envelopes2[6].round(1);
	freezeOn7 = envelopes2[7].round(1);
	freezeOn8 = envelopes2[8].round(1);
	freezeOn9 = envelopes2[9].round(1);
	freezeOn10 = envelopes2[10].round(1);
	freezeOn11 = envelopes2[11].round(1);
	freezeOn12 = envelopes2[12].round(1);

// Pan each granular synthesizer
	grain2Pan0 = Pan2.ar(triggersIn2[0], grain2PanArray0[0], 1) * envelopes2[0];
	grain2Pan1 = Pan2.ar(triggersIn2[1], grain2PanArray0[1], 1) * envelopes2[1];
	grain2Pan2 = Pan2.ar(triggersIn2[2], grain2PanArray0[2], 1) * envelopes2[2];
	grain2Pan3 = Pan2.ar(triggersIn2[3], grain2PanArray0[3], 1) * envelopes2[3];
	grain2Pan4 = Pan2.ar(triggersIn2[4], grain2PanArray0[4], 1) * envelopes2[4];
	grain2Pan5 = Pan2.ar(triggersIn2[5], grain2PanArray0[5], 1) * envelopes2[5];
	grain2Pan6 = Pan2.ar(triggersIn2[6], grain2PanArray0[6], 1) * envelopes2[6];
	grain2Pan7 = Pan2.ar(triggersIn2[7], grain2PanArray0[7], 1) * envelopes2[7];
	grain2Pan8 = Pan2.ar(triggersIn2[8], grain2PanArray0[8], 1) * envelopes2[8];
	grain2Pan9 = Pan2.ar(triggersIn2[9], grain2PanArray0[9], 1) * envelopes2[9];
	grain2Pan10 = Pan2.ar(triggersIn2[10], grain2PanArray0[10], 1) * envelopes2[10];
	grain2Pan11 = Pan2.ar(triggersIn2[11], grain2PanArray0[11], 1) * envelopes2[11];
	grain2Pan12 = Pan2.ar(triggersIn2[12], grain2PanArray0[12], 1) * envelopes2[12];

	feedback0GrainMix0 = grain2Pan0 + grain2Pan1 + grain2Pan2 + grain2Pan3 + grain2Pan4 + grain2Pan5 + grain2Pan6 + grain2Pan7 + grain2Pan8 + grain2Pan9 + grain2Pan10 + grain2Pan11 + grain2Pan12;

	freezeArray2 = [freezeOn0, freezeOn1, freezeOn2, freezeOn3, freezeOn4, freezeOn5, freezeOn6, freezeOn7, freezeOn8, freezeOn9, freezeOn10, freezeOn11, freezeOn12];

	triggersMix = (
	Pan2.ar(triggersIn2[0], grain2PanArray0[0]) +
	Pan2.ar(triggersIn2[1], grain2PanArray0[1]) +
	Pan2.ar(triggersIn2[2], grain2PanArray0[2]) +
	Pan2.ar(triggersIn2[3], grain2PanArray0[3]) +
	Pan2.ar(triggersIn2[4], grain2PanArray0[4]) +
	Pan2.ar(triggersIn2[5], grain2PanArray0[5]) +
	Pan2.ar(triggersIn2[6], grain2PanArray0[6]) +
	Pan2.ar(triggersIn2[7], grain2PanArray0[7]) +
	Pan2.ar(triggersIn2[8], grain2PanArray0[8]) +
	Pan2.ar(triggersIn2[9], grain2PanArray0[9]) +
	Pan2.ar(triggersIn2[10], grain2PanArray0[10]) +
	Pan2.ar(triggersIn2[11], grain2PanArray0[11]) +
	Pan2.ar(triggersIn2[12], grain2PanArray0[12]));

// send outputs to audio bus
	Out.ar(~grain2Bus0, (Pan2.ar(((feedback0GrainMix0 * feedback0[33]) + (triggersMix * feedback0[36])), 0, 1)));

// send pan values to control bus
	Out.kr(~pan2Bus0, grain2PanArray0);
	Out.kr(~freezeBus2, freezeArray2);

	}).send(s);


//Analyse selected inputs to obtain onsets

	SynthDef(\analysis,{

	arg osc0OnsetThreshold0 = 0.2,
	osc0OnsetThreshold1 = 0.2, osc0OnsetThreshold2 = 0.2, osc0OnsetThreshold3 = 0.2,
	osc0OnsetThreshold4 = 0.2,  osc0OnsetThreshold5 = 0.2,
	osc0OnsetThreshold6 = 0.2, osc0OnsetThreshold7 = 0.2, osc0OnsetThreshold8 = 0.2,
	osc0OnsetThreshold9 = 0.2, osc0OnsetThreshold10 = 0.2,
	osc0OnsetThreshold11 = 0.2, osc0OnsetThreshold12 = 0.2,
	osc1OnsetThreshold0 = 0.2, osc1OnsetThreshold1 = 0.2, osc1OnsetThreshold2 =
	0.2, osc1OnsetThreshold3 = 0.2, osc1OnsetThreshold4 = 0.2, osc1OnsetThreshold5 = 0.2, osc1OnsetThreshold6 = 0.2, osc1OnsetThreshold7 =
	0.2, osc1OnsetThreshold8 = 0.2, osc1OnsetThreshold9 = 0.2, osc1OnsetThreshold10 = 0.2, osc1OnsetThreshold11 = 0.2, osc1OnsetThreshold12 =
	0.2, onsetFeedback0 = #[0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2, 0.2], osc0Freq0 = 400, osc0Freq1 = 400, osc0Freq2 = 400, osc0Freq3 = 400, osc0Freq4 = 400, osc0Freq5 = 400, osc0Freq6 = 400, osc0Freq7 = 400, osc0Freq8 = 400, osc0Freq9 = 400, osc0Freq10 = 400, osc0Freq11 = 400, osc0Freq12 = 400,
	osc1Freq0 = 400, osc1Freq1 = 400, osc1Freq2 = 400, osc1Freq3 = 400, osc1Freq4 = 400, osc1Freq5 = 400, osc1Freq6 = 400, osc1Freq7 = 400, osc1Freq8 = 400, osc1Freq9 = 400, osc1Freq10 = 400, osc1Freq11 = 400, osc1Freq12 = 400,
	osc2Freq0 = 400, osc2Freq1 = 400, osc2Freq2 = 400, osc2Freq3 = 400, osc2Freq4 = 400, osc2Freq5 = 400, osc2Freq6 = 400, osc2Freq7 = 400, osc2Freq8 = 400, osc2Freq9 = 400, osc2Freq10 = 400, osc2Freq11 = 400, osc2Freq12 = 400, freqChooser0 = 0, freqChooser1 = 0, freqChooser2 = 0, res = 0.5, feedback0 = [], fftOn0 = 1, fftOn1 = 1, fftOn2 = 1;

	var osc0, osc1, osc2, bufferFilter0;

	var mfccData0 = [0,0,0,0,0,0,0,0,0,0,0,0,0], mfccData1 = [0,0,0,0,0,0,0,0,0,0,0,0,0], mfccFeedbackInvert = [0,0,0,0,0,0,0,0,0,0,0,0,0], filterData0 = [0,0,0,0,0,0,0,0,0,0,0,0,0], filterData1 = [0,0,0,0,0,0,0,0,0,0,0,0,0], filterData2 = [0,0,0,0,0,0,0,0,0,0,0,0,0], networkFilters0 = #[0,0,0,0,0,0,0,0,0,0,0,0,0], networkFilters1 = #[0,0,0,0,0,0,0,0,0,0,0,0,0], networkFilters2 = #[0,0,0,0,0,0,0,0,0,0,0,0,0];

	var osc0Filter0, osc0Filter1, osc0Filter2, osc0Filter3, osc0Filter4, osc0Filter5, osc0Filter6,
	osc0Filter7, osc0Filter8, osc0Filter9, osc0Filter10, osc0Filter11, osc0Filter12;

	var osc1Filter0, osc1Filter1, osc1Filter2, osc1Filter3, osc1Filter4, osc1Filter5, osc1Filter6,
	osc1Filter7, osc1Filter8, osc1Filter9, osc1Filter10, osc1Filter11, osc1Filter12;

	var osc2Filter0, osc2Filter1, osc2Filter2, osc2Filter3, osc2Filter4, osc2Filter5, osc2Filter6,
	osc2Filter7, osc2Filter8, osc2Filter9, osc2Filter10, osc2Filter11, osc2Filter12;

	var osc0OnsetChain0, osc0OnsetChain1, osc0OnsetChain2, osc0OnsetChain3, osc0OnsetChain4,
	osc0OnsetChain5, osc0OnsetChain6, osc0OnsetChain7, osc0OnsetChain8, osc0OnsetChain9,
	osc0OnsetChain10, osc0OnsetChain11, osc0OnsetChain12;

	var osc1OnsetChain0, osc1OnsetChain1, osc1OnsetChain2, osc1OnsetChain3, osc1OnsetChain4,
	osc1OnsetChain5, osc1OnsetChain6, osc1OnsetChain7, osc1OnsetChain8, osc1OnsetChain9,
	osc1OnsetChain10, osc1OnsetChain11, osc1OnsetChain12;

	var feedback0OnsetChain0, feedback0OnsetChain1, feedback0OnsetChain2, feedback0OnsetChain3,
	feedback0OnsetChain4, feedback0OnsetChain5, feedback0OnsetChain6, feedback0OnsetChain7,
	feedback0OnsetChain8, feedback0OnsetChain9, feedback0OnsetChain10, feedback0OnsetChain11,
	feedback0OnsetChain12;

	var osc0Onset0, osc0Onset1, osc0Onset2, osc0Onset3, osc0Onset4, osc0Onset5, osc0Onset6, osc0Onset7,
	osc0Onset8, osc0Onset9, osc0Onset10, osc0Onset11, osc0Onset12;

	var osc1Onset0, osc1Onset1, osc1Onset2, osc1Onset3, osc1Onset4, osc1Onset5, osc1Onset6, osc1Onset7,
	osc1Onset8, osc1Onset9, osc1Onset10, osc1Onset11, osc1Onset12;

	var feedback0Onset0, feedback0Onset1, feedback0Onset2, feedback0Onset3, feedback0Onset4,
	feedback0Onset5, feedback0Onset6, feedback0Onset7, feedback0Onset8, feedback0Onset9, feedback0Onset10,
	feedback0Onset11, feedback0Onset12;

	var threshold0Array0, threshold1Array0, onset0Array0, onset1Array0, onset2Array0, filterOut0, filterOut1, filterOut2;

	threshold0Array0 = [osc0OnsetThreshold0, osc0OnsetThreshold1, osc0OnsetThreshold2, osc0OnsetThreshold3,
	osc0OnsetThreshold4, osc0OnsetThreshold5, osc0OnsetThreshold6, osc0OnsetThreshold7, osc0OnsetThreshold8,
	osc0OnsetThreshold9, osc0OnsetThreshold10, osc0OnsetThreshold11, osc0OnsetThreshold12];

	threshold1Array0 = [osc1OnsetThreshold0, osc1OnsetThreshold1, osc1OnsetThreshold2, osc1OnsetThreshold3,
	osc1OnsetThreshold4, osc1OnsetThreshold5, osc1OnsetThreshold6, osc1OnsetThreshold7, osc1OnsetThreshold8,
	osc1OnsetThreshold9, osc1OnsetThreshold10, osc1OnsetThreshold11, osc1OnsetThreshold12];

// Obtain selected input from audio bus
	osc0 = InFeedback.ar(~bufferBus0, 1);
	osc1 = InFeedback.ar(~bufferBus1, 1);
	osc2 = InFeedback.ar(~osc2Bus0, 1);

// Collect spectral following process
	filterData0 = In.kr(~filterTracker0, 13);
	filterData1 = In.kr(~filterTracker1, 13);
	filterData2 = In.kr(~filterTracker2, 13);

	feedback0 = In.kr(~gui0Bus0, 63);

// filter input of control one relative to GUI or spectral following process
	osc0Filter0 = BBandPass.ar(osc0, Select.kr(feedback0[46], [osc0Freq0, Select.kr(feedback0[60], [filterData0[0], networkFilters0[0]])]), feedback0[57]);
	osc0Filter1 = BBandPass.ar(osc0, Select.kr(feedback0[46], [osc0Freq1, Select.kr(feedback0[60], [filterData0[1], networkFilters0[1]])]), feedback0[57]);
	osc0Filter2 = BBandPass.ar(osc0, Select.kr(feedback0[46], [osc0Freq2, Select.kr(feedback0[60], [filterData0[2], networkFilters0[2]])]), feedback0[57]);
	osc0Filter3 = BBandPass.ar(osc0, Select.kr(feedback0[46], [osc0Freq3, Select.kr(feedback0[60], [filterData0[3], networkFilters0[3]])]), feedback0[57]);
	osc0Filter4 = BBandPass.ar(osc0, Select.kr(feedback0[46], [osc0Freq4, Select.kr(feedback0[60], [filterData0[4], networkFilters0[4]])]), feedback0[57]);
	osc0Filter5 = BBandPass.ar(osc0, Select.kr(feedback0[46], [osc0Freq5, Select.kr(feedback0[60], [filterData0[5], networkFilters0[5]])]), feedback0[57]);
	osc0Filter6 = BBandPass.ar(osc0, Select.kr(feedback0[46], [osc0Freq6, Select.kr(feedback0[60], [filterData0[6], networkFilters0[6]])]), feedback0[57]);
	osc0Filter7 = BBandPass.ar(osc0, Select.kr(feedback0[46], [osc0Freq7, Select.kr(feedback0[60], [filterData0[7], networkFilters0[7]])]), feedback0[57]);
	osc0Filter8 = BBandPass.ar(osc0, Select.kr(feedback0[46], [osc0Freq8, Select.kr(feedback0[60], [filterData0[8], networkFilters0[8]])]), feedback0[57]);
	osc0Filter9 = BBandPass.ar(osc0, Select.kr(feedback0[46], [osc0Freq9, Select.kr(feedback0[60], [filterData0[9], networkFilters0[9]])]), feedback0[57]);
	osc0Filter10 = BBandPass.ar(osc0, Select.kr(feedback0[46], [osc0Freq10, Select.kr(feedback0[60], [filterData0[10], networkFilters0[10]])]), feedback0[57]);
	osc0Filter11 = BBandPass.ar(osc0, Select.kr(feedback0[46], [osc0Freq11, Select.kr(feedback0[60], [filterData0[11], networkFilters0[11]])]), feedback0[57]);
	osc0Filter12 = BBandPass.ar(osc0, Select.kr(feedback0[46], [osc0Freq12, Select.kr(feedback0[60], [filterData0[12], networkFilters0[12]])]), feedback0[57]);

// filter input of control two relative to GUI or spectral following process
	osc1Filter0 = BBandPass.ar(osc1, Select.kr(feedback0[47], [osc1Freq0, Select.kr(feedback0[60], [filterData1[0], networkFilters1[0]])]), feedback0[58]);
	osc1Filter1 = BBandPass.ar(osc1, Select.kr(feedback0[47], [osc1Freq1, Select.kr(feedback0[60], [filterData1[1], networkFilters1[1]])]), feedback0[58]);
	osc1Filter2 = BBandPass.ar(osc1, Select.kr(feedback0[47], [osc1Freq2, Select.kr(feedback0[60], [filterData1[2], networkFilters1[2]])]), feedback0[58]);
	osc1Filter3 = BBandPass.ar(osc1, Select.kr(feedback0[47], [osc1Freq3, Select.kr(feedback0[60], [filterData1[3], networkFilters1[3]])]), feedback0[58]);
	osc1Filter4 = BBandPass.ar(osc1, Select.kr(feedback0[47], [osc1Freq4, Select.kr(feedback0[60], [filterData1[4], networkFilters1[4]])]), feedback0[58]);
	osc1Filter5 = BBandPass.ar(osc1, Select.kr(feedback0[47], [osc1Freq5, Select.kr(feedback0[60], [filterData1[5], networkFilters1[5]])]), feedback0[58]);
	osc1Filter6 = BBandPass.ar(osc1, Select.kr(feedback0[47], [osc1Freq6, Select.kr(feedback0[60], [filterData1[6], networkFilters1[6]])]), feedback0[58]);
	osc1Filter7 = BBandPass.ar(osc1, Select.kr(feedback0[47], [osc1Freq7, Select.kr(feedback0[60], [filterData1[7], networkFilters1[7]])]), feedback0[58]);
	osc1Filter8 = BBandPass.ar(osc1, Select.kr(feedback0[47], [osc1Freq8, Select.kr(feedback0[60], [filterData1[8], networkFilters1[8]])]), feedback0[58]);
	osc1Filter9 = BBandPass.ar(osc1, Select.kr(feedback0[47], [osc1Freq9, Select.kr(feedback0[60], [filterData1[9], networkFilters1[9]])]), feedback0[58]);
	osc1Filter10 = BBandPass.ar(osc1, Select.kr(feedback0[47], [osc1Freq10, Select.kr(feedback0[60], [filterData1[10], networkFilters1[10]])]), feedback0[58]);
	osc1Filter11 = BBandPass.ar(osc1, Select.kr(feedback0[47], [osc1Freq11, Select.kr(feedback0[60], [filterData1[11], networkFilters1[11]])]), feedback0[58]);
	osc1Filter12 = BBandPass.ar(osc1, Select.kr(feedback0[47], [osc1Freq12, Select.kr(feedback0[60], [filterData1[12], networkFilters1[12]])]), feedback0[58]);

// filter input of control three relative to GUI or spectral following process
	osc2Filter0 = BBandPass.ar(osc2, Select.kr(feedback0[48], [osc2Freq0, Select.kr(feedback0[60], [filterData2[0], networkFilters2[0]])]), feedback0[59]);
	osc2Filter1 = BBandPass.ar(osc2, Select.kr(feedback0[48], [osc2Freq1, Select.kr(feedback0[60], [filterData2[1], networkFilters2[1]])]), feedback0[59]);
	osc2Filter2 = BBandPass.ar(osc2, Select.kr(feedback0[48], [osc2Freq2, Select.kr(feedback0[60], [filterData2[2], networkFilters2[2]])]), feedback0[59]);
	osc2Filter3 = BBandPass.ar(osc2, Select.kr(feedback0[48], [osc2Freq3, Select.kr(feedback0[60], [filterData2[3], networkFilters2[3]])]), feedback0[59]);
	osc2Filter4 = BBandPass.ar(osc2, Select.kr(feedback0[48], [osc2Freq4, Select.kr(feedback0[60], [filterData2[4], networkFilters2[4]])]), feedback0[59]);
	osc2Filter5 = BBandPass.ar(osc2, Select.kr(feedback0[48], [osc2Freq5, Select.kr(feedback0[60], [filterData2[5], networkFilters2[5]])]), feedback0[59]);
	osc2Filter6 = BBandPass.ar(osc2, Select.kr(feedback0[48], [osc2Freq6, Select.kr(feedback0[60], [filterData2[6], networkFilters2[6]])]), feedback0[59]);
	osc2Filter7 = BBandPass.ar(osc2, Select.kr(feedback0[48], [osc2Freq7, Select.kr(feedback0[60], [filterData2[7], networkFilters2[7]])]), feedback0[59]);
	osc2Filter8 = BBandPass.ar(osc2, Select.kr(feedback0[48], [osc2Freq8, Select.kr(feedback0[60], [filterData2[8], networkFilters2[8]])]), feedback0[59]);
	osc2Filter9 = BBandPass.ar(osc2, Select.kr(feedback0[48], [osc2Freq9, Select.kr(feedback0[60], [filterData2[9], networkFilters2[9]])]), feedback0[59]);
	osc2Filter10 = BBandPass.ar(osc2, Select.kr(feedback0[48], [osc2Freq10, Select.kr(feedback0[60], [filterData2[10], networkFilters2[10]])]), feedback0[59]);
	osc2Filter11 = BBandPass.ar(osc2, Select.kr(feedback0[48], [osc2Freq11, Select.kr(feedback0[60], [filterData2[11], networkFilters2[11]])]), feedback0[59]);
	osc2Filter12 = BBandPass.ar(osc2, Select.kr(feedback0[48], [osc2Freq12, Select.kr(feedback0[60], [filterData2[12], networkFilters2[12]])]), feedback0[59]);

// place filtered sources in to FFT buffers
	osc0OnsetChain0 = FFT(~osc0OnsetBuffer0[0], osc0Filter0, wintype:1, active:fftOn0);
	osc0OnsetChain1 = FFT(~osc0OnsetBuffer0[1], osc0Filter1, wintype:1, active:fftOn0);
	osc0OnsetChain2 = FFT(~osc0OnsetBuffer0[2], osc0Filter2, wintype:1, active:fftOn0);
	osc0OnsetChain3 = FFT(~osc0OnsetBuffer0[3], osc0Filter3, wintype:1, active:fftOn0);
	osc0OnsetChain4 = FFT(~osc0OnsetBuffer0[4], osc0Filter4, wintype:1, active:fftOn0);
	osc0OnsetChain5 = FFT(~osc0OnsetBuffer0[5], osc0Filter5, wintype:1, active:fftOn0);
	osc0OnsetChain6 = FFT(~osc0OnsetBuffer0[6], osc0Filter6, wintype:1, active:fftOn0);
	osc0OnsetChain7 = FFT(~osc0OnsetBuffer0[7], osc0Filter7, wintype:1, active:fftOn0);
	osc0OnsetChain8 = FFT(~osc0OnsetBuffer0[8], osc0Filter8, wintype:1, active:fftOn0);
	osc0OnsetChain9 = FFT(~osc0OnsetBuffer0[9], osc0Filter9, wintype:1, active:fftOn0);
	osc0OnsetChain10 = FFT(~osc0OnsetBuffer0[10], osc0Filter10, wintype:1, active:fftOn0);
	osc0OnsetChain11 = FFT(~osc0OnsetBuffer0[11], osc0Filter11, wintype:1, active:fftOn0);
	osc0OnsetChain12 = FFT(~osc0OnsetBuffer0[12], osc0Filter12, wintype:1, active:fftOn0);

	osc1OnsetChain0 = FFT(~osc1OnsetBuffer0[0], osc1Filter0, wintype:1, active:fftOn1);
	osc1OnsetChain1 = FFT(~osc1OnsetBuffer0[1], osc1Filter1, wintype:1, active:fftOn1);
	osc1OnsetChain2 = FFT(~osc1OnsetBuffer0[2], osc1Filter2, wintype:1, active:fftOn1);
	osc1OnsetChain3 = FFT(~osc1OnsetBuffer0[3], osc1Filter3, wintype:1, active:fftOn1);
	osc1OnsetChain4 = FFT(~osc1OnsetBuffer0[4], osc1Filter4, wintype:1, active:fftOn1);
	osc1OnsetChain5 = FFT(~osc1OnsetBuffer0[5], osc1Filter5, wintype:1, active:fftOn1);
	osc1OnsetChain6 = FFT(~osc1OnsetBuffer0[6], osc1Filter6, wintype:1, active:fftOn1);
	osc1OnsetChain7 = FFT(~osc1OnsetBuffer0[7], osc1Filter7, wintype:1, active:fftOn1);
	osc1OnsetChain8 = FFT(~osc1OnsetBuffer0[8], osc1Filter8, wintype:1, active:fftOn1);
	osc1OnsetChain9 = FFT(~osc1OnsetBuffer0[9], osc1Filter9, wintype:1, active:fftOn1);
	osc1OnsetChain10 = FFT(~osc1OnsetBuffer0[10], osc1Filter10, wintype:1, active:fftOn1);
	osc1OnsetChain11 = FFT(~osc1OnsetBuffer0[11], osc1Filter11, wintype:1, active:fftOn1);
	osc1OnsetChain12 = FFT(~osc1OnsetBuffer0[12], osc1Filter12, wintype:1, active:fftOn1);

	feedback0OnsetChain0 = FFT(~feedback0OnsetBuffer0[0], osc2Filter0, wintype:1, active:fftOn2);
	feedback0OnsetChain1 = FFT(~feedback0OnsetBuffer0[1], osc2Filter1, wintype:1, active:fftOn2);
	feedback0OnsetChain2 = FFT(~feedback0OnsetBuffer0[2], osc2Filter2, wintype:1, active:fftOn2);
	feedback0OnsetChain3 = FFT(~feedback0OnsetBuffer0[3], osc2Filter3, wintype:1, active:fftOn2);
	feedback0OnsetChain4 = FFT(~feedback0OnsetBuffer0[4], osc2Filter4, wintype:1, active:fftOn2);
	feedback0OnsetChain5 = FFT(~feedback0OnsetBuffer0[5], osc2Filter5, wintype:1, active:fftOn2);
	feedback0OnsetChain6 = FFT(~feedback0OnsetBuffer0[6], osc2Filter6, wintype:1, active:fftOn2);
	feedback0OnsetChain7 = FFT(~feedback0OnsetBuffer0[7], osc2Filter7, wintype:1, active:fftOn2);
	feedback0OnsetChain8 = FFT(~feedback0OnsetBuffer0[8], osc2Filter8, wintype:1, active:fftOn2);
	feedback0OnsetChain9 = FFT(~feedback0OnsetBuffer0[9], osc2Filter9, wintype:1, active:fftOn2);
	feedback0OnsetChain10 = FFT(~feedback0OnsetBuffer0[10], osc2Filter10, wintype:1, active:fftOn2);
	feedback0OnsetChain11 = FFT(~feedback0OnsetBuffer0[11], osc2Filter11, wintype:1, active:fftOn2);
	feedback0OnsetChain12 = FFT(~feedback0OnsetBuffer0[12], osc2Filter12, wintype:1, active:fftOn2);

// Extract onsets relative to thresholds set in GUI
	osc0Onset0 = Onsets.kr(osc0OnsetChain0, threshold0Array0[0], \phase);
	osc0Onset1 = Onsets.kr(osc0OnsetChain1, threshold0Array0[1], \phase);
	osc0Onset2 = Onsets.kr(osc0OnsetChain2, threshold0Array0[2], \phase);
	osc0Onset3 = Onsets.kr(osc0OnsetChain3, threshold0Array0[3], \phase);
	osc0Onset4 = Onsets.kr(osc0OnsetChain4, threshold0Array0[4], \phase);
	osc0Onset5 = Onsets.kr(osc0OnsetChain5, threshold0Array0[5], \phase);
	osc0Onset6 = Onsets.kr(osc0OnsetChain6, threshold0Array0[6], \phase);
	osc0Onset7 = Onsets.kr(osc0OnsetChain7, threshold0Array0[7], \phase);
	osc0Onset8 = Onsets.kr(osc0OnsetChain8, threshold0Array0[8], \phase);
	osc0Onset9 = Onsets.kr(osc0OnsetChain9, threshold0Array0[9], \phase);
	osc0Onset10 = Onsets.kr(osc0OnsetChain10, threshold0Array0[10], \phase);
	osc0Onset11 = Onsets.kr(osc0OnsetChain11, threshold0Array0[11], \phase);
	osc0Onset12 = Onsets.kr(osc0OnsetChain12, threshold0Array0[12], \phase);

	osc1Onset0 = Onsets.kr(osc1OnsetChain0, threshold1Array0[0], \phase);
	osc1Onset1 = Onsets.kr(osc1OnsetChain1, threshold1Array0[1], \phase);
	osc1Onset2 = Onsets.kr(osc1OnsetChain2, threshold1Array0[2], \phase);
	osc1Onset3 = Onsets.kr(osc1OnsetChain3, threshold1Array0[3], \phase);
	osc1Onset4 = Onsets.kr(osc1OnsetChain4, threshold1Array0[4], \phase);
	osc1Onset5 = Onsets.kr(osc1OnsetChain5, threshold1Array0[5], \phase);
	osc1Onset6 = Onsets.kr(osc1OnsetChain6, threshold1Array0[6], \phase);
	osc1Onset7 = Onsets.kr(osc1OnsetChain7, threshold1Array0[7], \phase);
	osc1Onset8 = Onsets.kr(osc1OnsetChain8, threshold1Array0[8], \phase);
	osc1Onset9 = Onsets.kr(osc1OnsetChain9, threshold1Array0[9], \phase);
	osc1Onset10 = Onsets.kr(osc1OnsetChain10, threshold1Array0[10], \phase);
	osc1Onset11 = Onsets.kr(osc1OnsetChain11, threshold1Array0[11], \phase);
	osc1Onset12 = Onsets.kr(osc1OnsetChain12, threshold1Array0[12], \phase);

	feedback0Onset0 = Onsets.kr(feedback0OnsetChain0, onsetFeedback0[0], \phase);
	feedback0Onset1 = Onsets.kr(feedback0OnsetChain1, onsetFeedback0[1], \phase);
	feedback0Onset2 = Onsets.kr(feedback0OnsetChain2, onsetFeedback0[2], \phase);
	feedback0Onset3 = Onsets.kr(feedback0OnsetChain3, onsetFeedback0[3], \phase);
	feedback0Onset4 = Onsets.kr(feedback0OnsetChain4, onsetFeedback0[4], \phase);
	feedback0Onset5 = Onsets.kr(feedback0OnsetChain5, onsetFeedback0[5], \phase);
	feedback0Onset6 = Onsets.kr(feedback0OnsetChain6, onsetFeedback0[6], \phase);
	feedback0Onset7 = Onsets.kr(feedback0OnsetChain7, onsetFeedback0[7], \phase);
	feedback0Onset8 = Onsets.kr(feedback0OnsetChain8, onsetFeedback0[8], \phase);
	feedback0Onset9 = Onsets.kr(feedback0OnsetChain9, onsetFeedback0[9], \phase);
	feedback0Onset10 = Onsets.kr(feedback0OnsetChain10, onsetFeedback0[10], \phase);
	feedback0Onset11 = Onsets.kr(feedback0OnsetChain11, onsetFeedback0[11], \phase);
	feedback0Onset12 = Onsets.kr(feedback0OnsetChain12, onsetFeedback0[12], \phase);

	onset0Array0 = [osc0Onset0, osc0Onset1, osc0Onset2, osc0Onset3, osc0Onset4, osc0Onset5, osc0Onset6,
	osc0Onset7, osc0Onset8, osc0Onset9, osc0Onset10, osc0Onset11, osc0Onset12];

	onset1Array0 = [osc1Onset0, osc1Onset1, osc1Onset2, osc1Onset3, osc1Onset4, osc1Onset5, osc1Onset6,
	osc1Onset7, osc1Onset8, osc1Onset9, osc1Onset10, osc1Onset11, osc1Onset12];

	onset2Array0 = [feedback0Onset0, feedback0Onset1, feedback0Onset2, feedback0Onset3, feedback0Onset4,
	feedback0Onset5, feedback0Onset6, feedback0Onset7, feedback0Onset8, feedback0Onset9, feedback0Onset10,
	feedback0Onset11, feedback0Onset12];

// output thresholds to control bus
	Out.kr(~threshold0Bus0, threshold0Array0);
	Out.kr(~threshold1Bus0, threshold1Array0);
	Out.kr(~onset0Bus0, onset0Array0);

// output onsets to control bus
	Out.kr(~onset1Bus0, onset1Array0);
	Out.kr(~onset2Bus0, onset2Array0);
	}).send(s);

//Spectral following mapping for control one

	SynthDef(\tracker0,{

	arg multiplier0 = 1, multiplier1 = 2, multiplier2 = 3, multiplier3 = 3.1, multiplier4 = 3.5, multiplier5 = 4, multiplier6 = 4.5, multiplier7 = 4, multiplier8 = 3.5, multiplier9 = 3.1, multiplier10 = 3, multiplier11 = 2, multiplier12 = 1;

	var filterControlOut0, filterControlOut1, filterControlOut2, feedback0 = [];

	var mfccData0 = [0,0,0,0,0,0,0,0,0,0,0,0,0], mfccData1 = [0,0,0,0,0,0,0,0,0,0,0,0,0], mfccData2 = [0,0,0,0,0,0,0,0,0,0,0,0,0];

// obtain MFCC values for control one
	mfccData0 = (In.kr(~mfccBus0, 13) * -1) + 1;

	feedback0 = In.kr(~gui0Bus0, 63);

// map values to filter frequencies
	filterControlOut0 = Out.kr(~filterTracker0, [
	((multiplier0*(mfccData0.sum**3)**1)+(feedback0[51])).min(4000).max(40),
	((multiplier1*(mfccData0.sum**3)**1)+(feedback0[51])).min(4000).max(40),
	((multiplier2*(mfccData0.sum**3)**1)+(feedback0[51])).min(4000).max(40),
	((multiplier3*(mfccData0.sum**3)**1)+(feedback0[51])).min(4000).max(40),
	((multiplier4*(mfccData0.sum**3)**1)+(feedback0[51])).min(4000).max(40),
	((multiplier5*(mfccData0.sum**3)**1)+(feedback0[51])).min(4000).max(40),
	((multiplier6*(mfccData0.sum**3)**1)+(feedback0[51])).min(4000).max(40),
	((multiplier7*(mfccData0.sum**3)**1)+(feedback0[51])).min(4000).max(40),
	((multiplier8*(mfccData0.sum**3)**1)+(feedback0[51])).min(4000).max(40),
	((multiplier9*(mfccData0.sum**3)**1)+(feedback0[51])).min(4000).max(40),
	((multiplier10*(mfccData0.sum**3)**1)+(feedback0[51])).min(4000).max(40),
	((multiplier11*(mfccData0.sum**3)**1)+(feedback0[51])).min(4000).max(40),
	((multiplier12*(mfccData0.sum**3)**1)+(feedback0[51])).min(4000).max(40)]);

	}).send(s);

//Spectral following mapping for control two
	SynthDef(\tracker1,{

	arg multiplier0 = 1, multiplier1 = 2, multiplier2 = 3, multiplier3 = 3.1, multiplier4 = 3.5, multiplier5 = 4, multiplier6 = 4.5, multiplier7 = 4, multiplier8 = 3.5, multiplier9 = 3.1, multiplier10 = 3, multiplier11 = 2, multiplier12 = 1;
	var filterControlOut0, filterControlOut1, filterControlOut2, feedback0 = [];

	var mfccData0 = [0,0,0,0,0,0,0,0,0,0,0,0,0], mfccData1 = [0,0,0,0,0,0,0,0,0,0,0,0,0], mfccData2 = [0,0,0,0,0,0,0,0,0,0,0,0,0];

// obtain MFCC values for control two
	mfccData1 = (In.kr(~mfccBus1, 13) * -1) + 1;

	feedback0 = In.kr(~gui0Bus0, 63);

// map values to filter frequencies
	filterControlOut1 = Out.kr(~filterTracker1, [
	((multiplier0*(mfccData1.sum**3)**1)+(feedback0[52])).min(4000).max(40),
	((multiplier1*(mfccData1.sum**3)**1)+(feedback0[52])).min(4000).max(40),
	((multiplier2*(mfccData1.sum**3)**1)+(feedback0[52])).min(4000).max(40),
	((multiplier3*(mfccData1.sum**3)**1)+(feedback0[52])).min(4000).max(40),
	((multiplier4*(mfccData1.sum**3)**1)+(feedback0[52])).min(4000).max(40),
	((multiplier5*(mfccData1.sum**3)**1)+(feedback0[52])).min(4000).max(40),
	((multiplier6*(mfccData1.sum**3)**1)+(feedback0[52])).min(4000).max(40),
	((multiplier7*(mfccData1.sum**3)**1)+(feedback0[52])).min(4000).max(40),
	((multiplier8*(mfccData1.sum**3)**1)+(feedback0[52])).min(4000).max(40),
	((multiplier9*(mfccData1.sum**3)**1)+(feedback0[52])).min(4000).max(40),
	((multiplier10*(mfccData1.sum**3)**1)+(feedback0[52])).min(4000).max(40),
	((multiplier11*(mfccData1.sum**3)**1)+(feedback0[52])).min(4000).max(40),
	((multiplier12*(mfccData1.sum**3)**1)+(feedback0[52])).min(4000).max(40)]);

	}).send(s);

//Spectral following mapping for control three
	SynthDef(\tracker2,{

	arg mfccFeedback = #[40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40];

	var filterControlOut2, feedback0 = [];

	feedback0 = In.kr(~gui0Bus0, 63);

// map values to filter frequencies

	filterControlOut2 = Out.kr(~filterTracker2, [
	((mfccFeedback[0])+(feedback0[53])).min(4000).max(40),
	((mfccFeedback[1])+(feedback0[53])).min(4000).max(40),
	((mfccFeedback[2])+(feedback0[53])).min(4000).max(40),
	((mfccFeedback[3])+(feedback0[53])).min(4000).max(40),
	((mfccFeedback[4])+(feedback0[53])).min(4000).max(40),
	((mfccFeedback[5])+(feedback0[53])).min(4000).max(40),
	((mfccFeedback[6])+(feedback0[53])).min(4000).max(40),
	((mfccFeedback[7])+(feedback0[53])).min(4000).max(40),
	((mfccFeedback[8])+(feedback0[53])).min(4000).max(40),
	((mfccFeedback[9])+(feedback0[53])).min(4000).max(40),
	((mfccFeedback[10])+(feedback0[53])).min(4000).max(40),
	((mfccFeedback[11])+(feedback0[53])).min(4000).max(40),
	((mfccFeedback[12])+(feedback0[53])).min(4000).max(40)]);

	}).send(s);

//Write slave sound-object to audio buffers for granular synthesizers triggered by control one

	SynthDef(\decimate0,{

	arg multiplier = 50, res = 0.1, meanUpdate = 4,
	freqChooser0 = 0, freqChooser1 = 0, filterChooser0 = 0, filterChooser1 = 0, filterChooser2 = 0, freqChooser2 = 0, filterLevel0 = 0, filterLevel1 = 0, filterLevel2 = 0, bitRate0 = 24, sampleRate0 = 1, bitRate1 = 24, sampleRate1 = 1, bitRate2 = 24, sampleRate2 = 1, level0 = 0, level1 = 0, level2 = 0, adjuster0 = 1, adjuster1 = 1, adjuster2 = 1, amplitude0 = 0, amplitude1 = 0, amplitude2 = 0, amplitude3 = 0, amplitude4 = 0, amplitude5 = 0, amplitude6 = 0, amplitude7 = 0, amplitude8 = 0, amplitude9 = 0, amplitude10 = 0, amplitude11 = 0, amplitude12 = 0, networkOnsets0 = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], naturalChooser0 = 0, naturalChooser1 = 0, naturalChooser2 = 0, naturalChooser3 = 0, naturalChooser4 = 0, naturalChooser5 = 0, naturalChooser6 = 0, naturalChooser7 = 0, naturalChooser8 = 0, naturalChooser9 = 0, naturalChooser10 = 0, naturalChooser11 = 0, naturalChooser12 = 0, networkChooser0 = 0;

	var osc2, bufferFilterHi0, bufferFilterHi1, bufferFilterHi2, bufferFilterHi3, bufferFilterHi4, bufferFilterHi5, bufferFilterHi6, bufferFilterHi7, bufferFilterHi8, bufferFilterHi9, bufferFilterHi10, bufferFilterHi11, bufferFilterHi12, bufferFilterLo0, bufferFilterLo1, bufferFilterLo2, bufferFilterLo3, bufferFilterLo4, bufferFilterLo5, bufferFilterLo6, bufferFilterLo7, bufferFilterLo8, bufferFilterLo9, bufferFilterLo10, bufferFilterLo11, bufferFilterLo12, meanTrigger, filtersIn0, filtersIn1, filtersIn2, levels0 = [], rates;

// Obtain slave from audio bus
	osc2 = InFeedback.ar(~osc2Bus0, 1);

// Obtain recording rates from control bus
	rates = In.kr(~grainPitch0Bus0, 13);

// Write slave to buffers
	bufferFilterHi0 = BufWr.ar(osc2, ~warpBuffer0[0],  Phasor.ar(0, BufRateScale.kr(~warpBuffer0[0].bufnum) * Select.kr(naturalChooser0, [1, rates[0]]), 0, BufFrames.kr(~warpBuffer0[0])));
	bufferFilterHi1 = BufWr.ar(osc2, ~warpBuffer0[1],  Phasor.ar(0, BufRateScale.kr(~warpBuffer0[1].bufnum) * Select.kr(naturalChooser1, [1, rates[1]]), 0, BufFrames.kr(~warpBuffer0[1])));
	bufferFilterHi2 = BufWr.ar(osc2, ~warpBuffer0[2],  Phasor.ar(0, BufRateScale.kr(~warpBuffer0[2].bufnum) * Select.kr(naturalChooser2, [1, rates[2]]), 0, BufFrames.kr(~warpBuffer0[2])));
	bufferFilterHi3 = BufWr.ar(osc2, ~warpBuffer0[3],  Phasor.ar(0, BufRateScale.kr(~warpBuffer0[3].bufnum) * Select.kr(naturalChooser3, [1, rates[3]]), 0, BufFrames.kr(~warpBuffer0[3])));
	bufferFilterHi4 = BufWr.ar(osc2, ~warpBuffer0[4],  Phasor.ar(0, BufRateScale.kr(~warpBuffer0[4].bufnum) * Select.kr(naturalChooser4, [1, rates[4]]), 0, BufFrames.kr(~warpBuffer0[4])));
	bufferFilterHi5 = BufWr.ar(osc2, ~warpBuffer0[5],  Phasor.ar(0, BufRateScale.kr(~warpBuffer0[5].bufnum) * Select.kr(naturalChooser5, [1, rates[5]]), 0, BufFrames.kr(~warpBuffer0[5])));
	bufferFilterHi6 = BufWr.ar(osc2, ~warpBuffer0[6],  Phasor.ar(0, BufRateScale.kr(~warpBuffer0[6].bufnum) * Select.kr(naturalChooser6, [1, rates[6]]), 0, BufFrames.kr(~warpBuffer0[6])));
	bufferFilterHi7 = BufWr.ar(osc2, ~warpBuffer0[7],  Phasor.ar(0, BufRateScale.kr(~warpBuffer0[7].bufnum) * Select.kr(naturalChooser7, [1, rates[7]]), 0, BufFrames.kr(~warpBuffer0[7])));
	bufferFilterHi8 = BufWr.ar(osc2, ~warpBuffer0[8],  Phasor.ar(0, BufRateScale.kr(~warpBuffer0[8].bufnum) * Select.kr(naturalChooser8, [1, rates[8]]), 0, BufFrames.kr(~warpBuffer0[8])));
	bufferFilterHi9 = BufWr.ar(osc2, ~warpBuffer0[9],  Phasor.ar(0, BufRateScale.kr(~warpBuffer0[9].bufnum) * Select.kr(naturalChooser9, [1, rates[9]]), 0, BufFrames.kr(~warpBuffer0[9])));
	bufferFilterHi10 = BufWr.ar(osc2, ~warpBuffer0[10],  Phasor.ar(0, BufRateScale.kr(~warpBuffer0[10].bufnum) * Select.kr(naturalChooser10, [1, rates[10]]), 0, BufFrames.kr(~warpBuffer0[10])));
	bufferFilterHi11 = BufWr.ar(osc2, ~warpBuffer0[11],  Phasor.ar(0, BufRateScale.kr(~warpBuffer0[11].bufnum) * Select.kr(naturalChooser11, [1, rates[11]]), 0, BufFrames.kr(~warpBuffer0[11])));
	bufferFilterHi12 = BufWr.ar(osc2, ~warpBuffer0[12],  Phasor.ar(0, BufRateScale.kr(~warpBuffer0[12].bufnum) * Select.kr(naturalChooser12, [1, rates[12]]), 0, BufFrames.kr(~warpBuffer0[12])));

		}).send(s);


//Write slave sound-object to audio buffers for granular synthesizers triggered by control two

	SynthDef(\decimate1,{

	arg  multiplier = 50, res = 0.1, meanUpdate = 4,
	freqChooser0 = 0, freqChooser1 = 0, filterChooser0 = 0, filterChooser1 = 0, filterChooser2 = 0, freqChooser2 = 0, filterLevel0 = 0, filterLevel1 = 0, filterLevel2 = 0, bitRate0 = 24, sampleRate0 = 1, bitRate1 = 24, sampleRate1 = 1, bitRate2 = 24, sampleRate2 = 1, level0 = 0, level1 = 0, level2 = 0, adjuster0 = 1, adjuster1 = 1, adjuster2 = 1, amplitude0 = 0, amplitude1 = 0, amplitude2 = 0, amplitude3 = 0, amplitude4 = 0, amplitude5 = 0, amplitude6 = 0, amplitude7 = 0, amplitude8 = 0, amplitude9 = 0, amplitude10 = 0, amplitude11 = 0, amplitude12 = 0,  naturalChooser0 = 0, naturalChooser1 = 0, naturalChooser2 = 0, naturalChooser3 = 0, naturalChooser4 = 0, naturalChooser5 = 0, naturalChooser6 = 0, naturalChooser7 = 0, naturalChooser8 = 0, naturalChooser9 = 0, naturalChooser10 = 0, naturalChooser11 = 0, naturalChooser12 = 0;

	var osc2, bufferFilterHi0, bufferFilterHi1, bufferFilterHi2, bufferFilterHi3, bufferFilterHi4, bufferFilterHi5, bufferFilterHi6, bufferFilterHi7, bufferFilterHi8, bufferFilterHi9, bufferFilterHi10, bufferFilterHi11, bufferFilterHi12, bufferFilterLo0, bufferFilterLo1, bufferFilterLo2, bufferFilterLo3, bufferFilterLo4, bufferFilterLo5, bufferFilterLo6, bufferFilterLo7, bufferFilterLo8, bufferFilterLo9, bufferFilterLo10, bufferFilterLo11, bufferFilterLo12, meanTrigger, filtersIn0, filtersIn1, filtersIn2, levels0 = [];

	var rates;

// Obtain slave from audio bus
	osc2 = InFeedback.ar(~osc2Bus0, 1);

// Obtain recording rates from control bus
	rates = In.kr(~grainPitch1Bus0, 13);

// Write slave to buffers
	bufferFilterHi0 = BufWr.ar(osc2, ~warpBuffer1[0],  Phasor.ar(0, BufRateScale.kr(~warpBuffer1[0].bufnum) * Select.kr(naturalChooser0, [1, rates[0]]), 0, BufFrames.kr(~warpBuffer1[0])));
	bufferFilterHi1 = BufWr.ar(osc2, ~warpBuffer1[1],  Phasor.ar(0, BufRateScale.kr(~warpBuffer1[1].bufnum) * Select.kr(naturalChooser1, [1, rates[1]]), 0, BufFrames.kr(~warpBuffer1[1])));
	bufferFilterHi2 = BufWr.ar(osc2, ~warpBuffer1[2],  Phasor.ar(0, BufRateScale.kr(~warpBuffer1[2].bufnum) * Select.kr(naturalChooser2, [1, rates[2]]), 0, BufFrames.kr(~warpBuffer1[2])));
	bufferFilterHi3 = BufWr.ar(osc2, ~warpBuffer1[3],  Phasor.ar(0, BufRateScale.kr(~warpBuffer1[3].bufnum) * Select.kr(naturalChooser3, [1, rates[3]]), 0, BufFrames.kr(~warpBuffer1[3])));
	bufferFilterHi4 = BufWr.ar(osc2, ~warpBuffer1[4],  Phasor.ar(0, BufRateScale.kr(~warpBuffer1[4].bufnum) * Select.kr(naturalChooser4, [1, rates[4]]), 0, BufFrames.kr(~warpBuffer1[4])));
	bufferFilterHi5 = BufWr.ar(osc2, ~warpBuffer1[5],  Phasor.ar(0, BufRateScale.kr(~warpBuffer1[5].bufnum) * Select.kr(naturalChooser5, [1, rates[5]]), 0, BufFrames.kr(~warpBuffer1[5])));
	bufferFilterHi6 = BufWr.ar(osc2, ~warpBuffer1[6],  Phasor.ar(0, BufRateScale.kr(~warpBuffer1[6].bufnum) * Select.kr(naturalChooser6, [1, rates[6]]), 0, BufFrames.kr(~warpBuffer1[6])));
	bufferFilterHi7 = BufWr.ar(osc2, ~warpBuffer1[7],  Phasor.ar(0, BufRateScale.kr(~warpBuffer1[7].bufnum) * Select.kr(naturalChooser7, [1, rates[7]]), 0, BufFrames.kr(~warpBuffer1[7])));
	bufferFilterHi8 = BufWr.ar(osc2, ~warpBuffer1[8],  Phasor.ar(0, BufRateScale.kr(~warpBuffer1[8].bufnum) * Select.kr(naturalChooser8, [1, rates[8]]), 0, BufFrames.kr(~warpBuffer1[8])));
	bufferFilterHi9 = BufWr.ar(osc2, ~warpBuffer1[9],  Phasor.ar(0, BufRateScale.kr(~warpBuffer1[9].bufnum) * Select.kr(naturalChooser9, [1, rates[9]]), 0, BufFrames.kr(~warpBuffer1[9])));
	bufferFilterHi10 = BufWr.ar(osc2, ~warpBuffer1[10],  Phasor.ar(0, BufRateScale.kr(~warpBuffer1[10].bufnum) * Select.kr(naturalChooser10, [1, rates[10]]), 0, BufFrames.kr(~warpBuffer1[10])));
	bufferFilterHi11 = BufWr.ar(osc2, ~warpBuffer1[11],  Phasor.ar(0, BufRateScale.kr(~warpBuffer1[11].bufnum) * Select.kr(naturalChooser11, [1, rates[11]]), 0, BufFrames.kr(~warpBuffer1[11])));
	bufferFilterHi12 = BufWr.ar(osc2, ~warpBuffer1[12],  Phasor.ar(0, BufRateScale.kr(~warpBuffer1[12].bufnum) * Select.kr(naturalChooser12, [1, rates[12]]), 0, BufFrames.kr(~warpBuffer1[12])));

		}).send(s);

//Write slave sound-object to audio buffers for granular synthesizers triggered by control three/slave

	SynthDef(\decimate2,{

	arg multiplier = 50, res = 0.1, meanUpdate = 4,
	freqChooser0 = 0, freqChooser1 = 0, filterChooser0 = 0, filterChooser1 = 0, filterChooser2 = 0, freqChooser2 = 0, filterLevel0 = 0, filterLevel1 = 0, filterLevel2 = 0, bitRate0 = 24, sampleRate0 = 1, bitRate1 = 24, sampleRate1 = 1, bitRate2 = 24, sampleRate2 = 1, level0 = 0, level1 = 0, level2 = 0, adjuster0 = 1, adjuster1 = 1, adjuster2 = 1, amplitude0 = 0, amplitude1 = 0, amplitude2 = 0, amplitude3 = 0, amplitude4 = 0, amplitude5 = 0, amplitude6 = 0, amplitude7 = 0, amplitude8 = 0, amplitude9 = 0, amplitude10 = 0, amplitude11 = 0, amplitude12 = 0, pitchArray0 = #[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], naturalChooser0 = 0, naturalChooser1 = 0, naturalChooser2 = 0, naturalChooser3 = 0, naturalChooser4 = 0, naturalChooser5 = 0, naturalChooser6 = 0, naturalChooser7 = 0, naturalChooser8 = 0, naturalChooser9 = 0, naturalChooser10 = 0, naturalChooser11 = 0, naturalChooser12 = 0;

	var osc2, bufferFilterHi0, bufferFilterHi1, bufferFilterHi2, bufferFilterHi3, bufferFilterHi4, bufferFilterHi5, bufferFilterHi6, bufferFilterHi7, bufferFilterHi8, bufferFilterHi9, bufferFilterHi10, bufferFilterHi11, bufferFilterHi12, bufferFilterLo0, bufferFilterLo1, bufferFilterLo2, bufferFilterLo3, bufferFilterLo4, bufferFilterLo5, bufferFilterLo6, bufferFilterLo7, bufferFilterLo8, bufferFilterLo9, bufferFilterLo10, bufferFilterLo11, bufferFilterLo12, meanTrigger, filtersIn0, filtersIn1, filtersIn2, levels0 = [];

	var osc0Limiter0, osc0Limiter1, osc0Limiter2, osc0Limiter3, osc0Limiter4, osc0Limiter5, osc0Limiter6, osc0Limiter7, osc0Limiter8, osc0Limiter9, osc0Limiter10, osc0Limiter11, osc0Limiter12, rates;

	var osc1Limiter0, osc1Limiter1, osc1Limiter2, osc1Limiter3, osc1Limiter4, osc1Limiter5, osc1Limiter6, osc1Limiter7, osc1Limiter8, osc1Limiter9, osc1Limiter10, osc1Limiter11, osc1Limiter12;

	var osc2Limiter0, osc2Limiter1, osc2Limiter2, osc2Limiter3, osc2Limiter4, osc2Limiter5, osc2Limiter6, osc2Limiter7, osc2Limiter8, osc2Limiter9, osc2Limiter10, osc2Limiter11, osc2Limiter12;

	var osc0HPFCutoff0, osc0LPFCutoff0, osc1HPFCutoff0, osc1LPFCutoff0, osc2HPFCutoff0, osc2LPFCutoff0;

	var osc0Decimate0, osc0Decimate1, osc0Decimate2, osc0Decimate3, osc0Decimate4, osc0Decimate5, osc0Decimate6, osc0Decimate7, osc0Decimate8, osc0Decimate9, osc0Decimate10, osc0Decimate11, osc0Decimate12;

	var osc1Decimate0, osc1Decimate1, osc1Decimate2, osc1Decimate3, osc1Decimate4, osc1Decimate5, osc1Decimate6, osc1Decimate7, osc1Decimate8, osc1Decimate9, osc1Decimate10, osc1Decimate11, osc1Decimate12;

	var osc2Decimate0, osc2Decimate1, osc2Decimate2, osc2Decimate3, osc2Decimate4, osc2Decimate5, osc2Decimate6, osc2Decimate7, osc2Decimate8, osc2Decimate9, osc2Decimate10, osc2Decimate11, osc2Decimate12;

// Obtain slave from audio bus
	osc2 = InFeedback.ar(~osc2Bus0, 1);

// Write slave to buffers
	bufferFilterHi0 = BufWr.ar(osc2, ~warpBuffer2[0],  Phasor.ar(0, BufRateScale.kr(~warpBuffer2[0].bufnum) * Select.kr(naturalChooser0, [1, pitchArray0[0]]), 0, BufFrames.kr(~warpBuffer2[0])));
	bufferFilterHi1 = BufWr.ar(osc2, ~warpBuffer2[1],  Phasor.ar(0, BufRateScale.kr(~warpBuffer2[1].bufnum) * Select.kr(naturalChooser1, [1, pitchArray0[1]]), 0, BufFrames.kr(~warpBuffer2[1])));
	bufferFilterHi2 = BufWr.ar(osc2, ~warpBuffer2[2],  Phasor.ar(0, BufRateScale.kr(~warpBuffer2[2].bufnum) * Select.kr(naturalChooser2, [1, pitchArray0[2]]), 0, BufFrames.kr(~warpBuffer2[2])));
	bufferFilterHi3 = BufWr.ar(osc2, ~warpBuffer2[3],  Phasor.ar(0, BufRateScale.kr(~warpBuffer2[3].bufnum) * Select.kr(naturalChooser3, [1, pitchArray0[3]]), 0, BufFrames.kr(~warpBuffer2[3])));
	bufferFilterHi4 = BufWr.ar(osc2, ~warpBuffer2[4],  Phasor.ar(0, BufRateScale.kr(~warpBuffer2[4].bufnum) * Select.kr(naturalChooser4, [1, pitchArray0[4]]), 0, BufFrames.kr(~warpBuffer2[4])));
	bufferFilterHi5 = BufWr.ar(osc2, ~warpBuffer2[5],  Phasor.ar(0, BufRateScale.kr(~warpBuffer2[5].bufnum) * Select.kr(naturalChooser5, [1, pitchArray0[5]]), 0, BufFrames.kr(~warpBuffer2[5])));
	bufferFilterHi6 = BufWr.ar(osc2, ~warpBuffer2[6],  Phasor.ar(0, BufRateScale.kr(~warpBuffer2[6].bufnum) * Select.kr(naturalChooser6, [1, pitchArray0[6]]), 0, BufFrames.kr(~warpBuffer2[6])));
	bufferFilterHi7 = BufWr.ar(osc2, ~warpBuffer2[7],  Phasor.ar(0, BufRateScale.kr(~warpBuffer2[7].bufnum) * Select.kr(naturalChooser7, [1, pitchArray0[7]]), 0, BufFrames.kr(~warpBuffer2[7])));
	bufferFilterHi8 = BufWr.ar(osc2, ~warpBuffer2[8],  Phasor.ar(0, BufRateScale.kr(~warpBuffer2[8].bufnum) * Select.kr(naturalChooser8, [1, pitchArray0[8]]), 0, BufFrames.kr(~warpBuffer2[8])));
	bufferFilterHi9 = BufWr.ar(osc2, ~warpBuffer2[9],  Phasor.ar(0, BufRateScale.kr(~warpBuffer2[9].bufnum) * Select.kr(naturalChooser9, [1, pitchArray0[9]]), 0, BufFrames.kr(~warpBuffer2[9])));
	bufferFilterHi10 = BufWr.ar(osc2, ~warpBuffer2[10],  Phasor.ar(0, BufRateScale.kr(~warpBuffer2[10].bufnum) * Select.kr(naturalChooser10, [1, pitchArray0[10]]), 0, BufFrames.kr(~warpBuffer2[10])));
	bufferFilterHi11 = BufWr.ar(osc2, ~warpBuffer2[11],  Phasor.ar(0, BufRateScale.kr(~warpBuffer2[11].bufnum) * Select.kr(naturalChooser11, [1, pitchArray0[11]]), 0, BufFrames.kr(~warpBuffer2[11])));
	bufferFilterHi12 = BufWr.ar(osc2, ~warpBuffer2[12],  Phasor.ar(0, BufRateScale.kr(~warpBuffer2[12].bufnum) * Select.kr(naturalChooser12, [1, pitchArray0[12]]), 0, BufFrames.kr(~warpBuffer2[12])));

		}).send(s);

//Generate envelopes for granular synthesizers

	SynthDef(\envelope,{

	arg grain0Attack0 = 0.1, grain0Release0 = 0.1 , grain0Amplitude0 = 0, grain0Attack1 = 0.1, grain0Release1 = 1, grain0Amplitude1 = 0, grain0Attack2 = 0.1, grain0Release2 = 0.1, grain0Amplitude2 = 0, grain0Attack3 = 0.1, grain0Release3 = 1 , grain0Amplitude3 = 0, grain0Attack4 = 0.1, grain0Release4 = 0.1, grain0Amplitude4 = 0, grain0Attack5 = 0.1, grain0Release5 = 0.1, grain0Amplitude5 = 0, grain0Attack6 = 0.1, grain0Release6 = 0.1 , grain0Amplitude6 = 0, grain0Attack7 = 0.1, grain0Release7 = 0.1, grain0Amplitude7 = 0, grain0Attack8 = 0.1, grain0Release8 = 0.1, grain0Amplitude8 = 0, grain0Attack9 = 0.1, grain0Release9 = 0.1 , grain0Amplitude9 = 0, grain0Attack10 = 0.1, grain0Release10 = 0.1, grain0Amplitude10 = 0, grain0Attack11 = 0.1, grain0Release11 = 0.1, grain0Amplitude11 = 0, grain0Attack12 = 0.1, grain0Release12 = 0.1 , grain0Amplitude12 = 0,

	grain1Attack0 = 0.1, grain1Release0 = 0.1 , grain1Amplitude0 = 0, grain1Attack1 = 0.1, grain1Release1 = 0.1, grain1Amplitude1 = 0, grain1Attack2 = 0.1, grain1Release2 = 0.1, grain1Amplitude2 = 0, grain1Attack3 = 0.1, grain1Release3 = 0.1 , grain1Amplitude3 = 0, grain1Attack4 = 0.1, grain1Release4 = 0.1, grain1Amplitude4 = 0, grain1Attack5 = 0.1, grain1Release5 = 0.1, grain1Amplitude5 = 0, grain1Attack6 = 0.1, grain1Release6 = 0.1 , grain1Amplitude6 = 0, grain1Attack7 = 0.1, grain1Release7 = 0.1, grain1Amplitude7 = 0, grain1Attack8 = 0.1, grain1Release8 = 0.1, grain1Amplitude8 = 0, grain1Attack9 = 0.1, grain1Release9 = 0.1 , grain1Amplitude9 = 0, grain1Attack10 = 0.1, grain1Release10 = 0.1, grain1Amplitude10 = 0, grain1Attack11 = 0.1, grain1Release11 = 0.1, grain1Amplitude11 = 0, grain1Attack12 = 0.1, grain1Release12 = 0.1 , grain1Amplitude12 = 0,

	envelopeFeedback0 = #[0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0.1, 0], networkOnsets0 = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], networkOnsets1 = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], networkOnsets2 = #[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

	var onsets0, onsets1, onsets2, durations0, durations1, durations2, mfccData0, mfccData1, mfccData2, feedback0 = [], networkChooser0;

	var onset0Envelope0, onset0Envelope1, onset0Envelope2, onset0Envelope3, onset0Envelope4, onset0Envelope5,
	onset0Envelope6, onset0Envelope7, onset0Envelope8, onset0Envelope9, onset0Envelope10, onset0Envelope11,
	onset0Envelope12;

	var onset1Envelope0, onset1Envelope1, onset1Envelope2, onset1Envelope3, onset1Envelope4, onset1Envelope5,
	onset1Envelope6, onset1Envelope7, onset1Envelope8, onset1Envelope9, onset1Envelope10, onset1Envelope11,
	onset1Envelope12;

	var feedback0Envelope0,  feedback0Envelope1,  feedback0Envelope2,  feedback0Envelope3,  feedback0Envelope4, feedback0Envelope5, feedback0Envelope6, feedback0Envelope7, feedback0Envelope8, feedback0Envelope9, feedback0Envelope10, feedback0Envelope11, feedback0Envelope12;

	var onset0Env0, onset0Env1, onset0Env2, onset0Env3, onset0Env4, onset0Env5, onset0Env6, onset0Env7, onset0Env8, onset0Env9, onset0Env10, onset0Env11, onset0Env12;

	var onset1Env0, onset1Env1, onset1Env2, onset1Env3, onset1Env4, onset1Env5, onset1Env6, onset1Env7, onset1Env8, onset1Env9, onset1Env10, onset1Env11, onset1Env12;

	var feedback0Env0, feedback0Env1, feedback0Env2, feedback0Env3, feedback0Env4, feedback0Env5, feedback0Env6, feedback0Env7, feedback0Env8, feedback0Env9, feedback0Env10, feedback0Env11, feedback0Env12;

	var osc0gate0, osc0gate1, osc0gate2, osc0gate3, osc0gate4, osc0gate5, osc0gate6, osc0gate7, osc0gate8, osc0gate9, osc0gate10, osc0gate11, osc0gate12;

	var osc1gate0, osc1gate1, osc1gate2, osc1gate3, osc1gate4, osc1gate5, osc1gate6, osc1gate7, osc1gate8, osc1gate9, osc1gate10, osc1gate11, osc1gate12;

	var feedbackGate0, feedbackGate1, feedbackGate2, feedbackGate3, feedbackGate4, feedbackGate5, feedbackGate6, feedbackGate7, feedbackGate8, feedbackGate9, feedbackGate10, feedbackGate11, feedbackGate12;

	var guiGateMix0, triggersArray0, triggersArray1, envelopeArray0, envelopeArray1, envelopeArray2, grainEnvelopeArray0, guiEnvelopeArray0, guiEnvelopeArray1;

// Obtain onsets of control one
	onsets0 = In.kr(~onset0Bus0, 13);
	durations0 = In.kr(~duration0Bus0, 13);

// Obtain onsets of control two
	onsets1 = In.kr(~onset1Bus0, 13);
	durations1 = In.kr(~duration1Bus0, 13);

// Obtain onsets of control three
	onsets2 = In.kr(~onset2Bus0, 13);
	durations2 = In.kr(~duration2Bus0, 13);

	feedback0 = In.kr(~gui0Bus0, 63);

	networkChooser0 = feedback0[60];

// Envelopes triggered by onsets of control one
	onset0Envelope0 = Env.linen(grain0Attack0 * durations0[0] , durations0[0] - ((grain0Attack0 * durations0[0]) + (grain0Release0 * durations0[0])), grain0Release0 * durations0[0], grain0Amplitude0, 'sine');
	onset0Env0 = EnvGen.kr(onset0Envelope0, Select.kr(networkChooser0,[onsets0[0], networkOnsets0[0]]), 1);
	onset0Envelope1 = Env.linen(grain0Attack1 * durations0[1] , durations0[1] - ((grain0Attack1 * durations0[1]) + (grain0Release1 * durations0[1])), grain0Release1 * durations0[1], grain0Amplitude1, 'sine');
	onset0Env1 = EnvGen.kr(onset0Envelope1, Select.kr(networkChooser0,[onsets0[1], networkOnsets0[1]]), 1);
	onset0Envelope2 = Env.linen(grain0Attack2 * durations0[2] , durations0[2] - ((grain0Attack2 * durations0[2]) + (grain0Release2 * durations0[2])), grain0Release2 * durations0[2], grain0Amplitude2, 'sine');
	onset0Env2 = EnvGen.kr(onset0Envelope2, Select.kr(networkChooser0,[onsets0[2], networkOnsets0[2]]), 1);
	onset0Envelope3 = Env.linen(grain0Attack3 * durations0[3] , durations0[3] - ((grain0Attack3 * durations0[3]) + (grain0Release3 * durations0[3])), grain0Release3 * durations0[3], grain0Amplitude3, 'sine');
	onset0Env3 = EnvGen.kr(onset0Envelope3, Select.kr(networkChooser0,[onsets0[3], networkOnsets0[3]]), 1);
	onset0Envelope4 = Env.linen(grain0Attack4 * durations0[4] , durations0[4] - ((grain0Attack4 * durations0[4]) + (grain0Release4 * durations0[4])), grain0Release4 * durations0[4], grain0Amplitude4, 'sine');
	onset0Env4 = EnvGen.kr(onset0Envelope4, Select.kr(networkChooser0,[onsets0[4], networkOnsets0[4]]), 1);
	onset0Envelope5 = Env.linen(grain0Attack5 * durations0[5] , durations0[5] - ((grain0Attack5 * durations0[5]) + (grain0Release5 * durations0[5])), grain0Release5 * durations0[5], grain0Amplitude5, 'sine');
	onset0Env5 = EnvGen.kr(onset0Envelope5, Select.kr(networkChooser0,[onsets0[5], networkOnsets0[5]]), 1);
	onset0Envelope6 = Env.linen(grain0Attack6 * durations0[6] , durations0[6] - ((grain0Attack6 * durations0[6]) + (grain0Release6 * durations0[6])), grain0Release6 * durations0[6], grain0Amplitude6, 'sine');
	onset0Env6 = EnvGen.kr(onset0Envelope6, Select.kr(networkChooser0,[onsets0[6], networkOnsets0[6]]), 1);
	onset0Envelope7 = Env.linen(grain0Attack7 * durations0[7] , durations0[7] - ((grain0Attack7 * durations0[7]) + (grain0Release7 * durations0[7])), grain0Release7 * durations0[7], grain0Amplitude7, 'sine');
	onset0Env7 = EnvGen.kr(onset0Envelope7, Select.kr(networkChooser0,[onsets0[7], networkOnsets0[7]]), 1);
	onset0Envelope8 = Env.linen(grain0Attack8 * durations0[8] , durations0[8] - ((grain0Attack8 * durations0[8]) + (grain0Release8 * durations0[8])), grain0Release8 * durations0[8], grain0Amplitude8, 'sine');
	onset0Env8 = EnvGen.kr(onset0Envelope8, Select.kr(networkChooser0,[onsets0[8], networkOnsets0[8]]), 1);
	onset0Envelope9 = Env.linen(grain0Attack9 * durations0[9] , durations0[9] - ((grain0Attack9 * durations0[9]) + (grain0Release9 * durations0[9])), grain0Release9 * durations0[9], grain0Amplitude9, 'sine');
	onset0Env9 = EnvGen.kr(onset0Envelope9, Select.kr(networkChooser0,[onsets0[9], networkOnsets0[9]]), 1);
	onset0Envelope10 = Env.linen(grain0Attack10 * durations0[10] , durations0[10] - ((grain0Attack10 * durations0[10]) + (grain0Release10 * durations0[10])), grain0Release10 * durations0[10], grain0Amplitude10, 'sine');
	onset0Env10 = EnvGen.kr(onset0Envelope10, Select.kr(networkChooser0,[onsets0[10], networkOnsets0[10]]), 1);
	onset0Envelope11 = Env.linen(grain0Attack11 * durations0[11] , durations0[11] - ((grain0Attack11 * durations0[11]) + (grain0Release11 * durations0[11])), grain0Release11 * durations0[11], grain0Amplitude11, 'sine');
	onset0Env11 = EnvGen.kr(onset0Envelope11, Select.kr(networkChooser0,[onsets0[11], networkOnsets0[11]]), 1);
	onset0Envelope12 = Env.linen(grain0Attack12 * durations0[12] , durations0[12] - ((grain0Attack12 * durations0[12]) + (grain0Release12 * durations0[12])), grain0Release12 * durations0[12], grain0Amplitude12, 'sine');
	onset0Env12 = EnvGen.kr(onset0Envelope12, Select.kr(networkChooser0,[onsets0[12], networkOnsets0[12]]), 1);

// Envelopes triggered by onsets of control two
	onset1Envelope0 = Env.linen(grain1Attack0 * durations1[0] , durations1[0] - ((grain1Attack0 * durations1[0]) + (grain1Release0 * durations1[0])), grain1Release0 * durations1[0], grain1Amplitude0, 'sine');
	onset1Env0 = EnvGen.kr(onset1Envelope0, Select.kr(networkChooser0,[onsets1[0], networkOnsets1[0]]), 1);
	onset1Envelope1 = Env.linen(grain1Attack1 * durations1[1] , durations1[1] - ((grain1Attack1 * durations1[1]) + (grain1Release1 * durations1[1])), grain1Release1 * durations1[1], grain1Amplitude1, 'sine');
	onset1Env1 = EnvGen.kr(onset1Envelope1, Select.kr(networkChooser0,[onsets1[1], networkOnsets1[1]]), 1);
	onset1Envelope2 = Env.linen(grain1Attack2 * durations1[2] , durations1[2] - ((grain1Attack2 * durations1[2]) + (grain1Release2 * durations1[2])), grain1Release2 * durations1[2], grain1Amplitude2, 'sine');
	onset1Env2 = EnvGen.kr(onset1Envelope2, Select.kr(networkChooser0,[onsets1[2], networkOnsets1[2]]), 1);
	onset1Envelope3 = Env.linen(grain1Attack3 * durations1[3] , durations1[3] - ((grain1Attack3 * durations1[3]) + (grain1Release3 * durations1[3])), grain1Release3 * durations1[3], grain1Amplitude3, 'sine');
	onset1Env3 = EnvGen.kr(onset1Envelope3, Select.kr(networkChooser0,[onsets1[3], networkOnsets1[3]]), 1);
	onset1Envelope4 = Env.linen(grain1Attack4 * durations1[4] , durations1[4] - ((grain1Attack4 * durations1[4]) + (grain1Release4 * durations1[4])), grain1Release4 * durations1[4], grain1Amplitude4, 'sine');
	onset1Env4 = EnvGen.kr(onset1Envelope4, Select.kr(networkChooser0,[onsets1[4], networkOnsets1[4]]), 1);
	onset1Envelope5 = Env.linen(grain1Attack5 * durations1[5] , durations1[5] - ((grain1Attack5 * durations1[5]) + (grain1Release5 * durations1[5])), grain1Release5 * durations1[5], grain1Amplitude5, 'sine');
	onset1Env5 = EnvGen.kr(onset1Envelope5, Select.kr(networkChooser0,[onsets1[5], networkOnsets1[5]]), 1);
	onset1Envelope6 = Env.linen(grain1Attack6 * durations1[6] , durations1[6] - ((grain1Attack6 * durations1[6]) + (grain1Release6 * durations1[6])), grain1Release6 * durations1[6], grain1Amplitude6, 'sine');
	onset1Env6 = EnvGen.kr(onset1Envelope6, Select.kr(networkChooser0,[onsets1[6], networkOnsets1[6]]), 1);
	onset1Envelope7 = Env.linen(grain1Attack7 * durations1[7] , durations1[7] - ((grain1Attack7 * durations1[7]) + (grain1Release7 * durations1[7])), grain1Release7 * durations1[7], grain1Amplitude7, 'sine');
	onset1Env7 = EnvGen.kr(onset1Envelope7, Select.kr(networkChooser0,[onsets1[7], networkOnsets1[7]]), 1);
	onset1Envelope8 = Env.linen(grain1Attack8 * durations1[8] , durations1[8] - ((grain1Attack8 * durations1[8]) + (grain1Release8 * durations1[8])), grain1Release8 * durations1[8], grain1Amplitude8, 'sine');
	onset1Env8 = EnvGen.kr(onset1Envelope8, Select.kr(networkChooser0,[onsets1[8], networkOnsets1[8]]), 1);
	onset1Envelope9 = Env.linen(grain1Attack9 * durations1[9] , durations1[9] - ((grain1Attack9 * durations1[9]) + (grain1Release9 * durations1[9])), grain1Release9 * durations1[9], grain1Amplitude9, 'sine');
	onset1Env9 = EnvGen.kr(onset1Envelope9, Select.kr(networkChooser0,[onsets1[9], networkOnsets1[9]]), 1);
	onset1Envelope10 = Env.linen(grain1Attack10 * durations1[10] , durations1[10] - ((grain1Attack10 * durations1[10]) + (grain1Release10 * durations1[10])), grain1Release10 * durations1[10], grain1Amplitude10, 'sine');
	onset1Env10 = EnvGen.kr(onset1Envelope10, Select.kr(networkChooser0,[onsets1[10], networkOnsets1[10]]), 1);
	onset1Envelope11 = Env.linen(grain1Attack11 * durations1[11] , durations1[11] - ((grain1Attack11 * durations1[11]) + (grain1Release11 * durations1[11])), grain1Release11 * durations1[11], grain1Amplitude11, 'sine');
	onset1Env11 = EnvGen.kr(onset1Envelope11, Select.kr(networkChooser0,[onsets1[11], networkOnsets1[11]]), 1);
	onset1Envelope12 = Env.linen(grain1Attack12 * durations1[12] , durations1[12] - ((grain1Attack12 * durations1[12]) + (grain1Release12 * durations1[12])), grain1Release12 * durations1[12], grain1Amplitude12, 'sine');
	onset1Env12 = EnvGen.kr(onset1Envelope12, Select.kr(networkChooser0,[onsets1[12], networkOnsets1[12]]), 1);

// Envelopes triggered by onsets of control three

	feedback0Envelope0 = Env.linen(envelopeFeedback0[0] * durations2[0], durations2[0] - ((envelopeFeedback0[0] * durations2[0]) + (envelopeFeedback0[1] * durations2[0])), envelopeFeedback0[1] * durations2[0], (envelopeFeedback0[2].min(1)), 'sine');
	feedback0Env0 = EnvGen.kr(feedback0Envelope0, Select.kr(networkChooser0,[onsets2[0], networkOnsets2[0]]), 1);
	feedback0Envelope1 = Env.linen(envelopeFeedback0[3] * durations2[1], durations2[1] - ((envelopeFeedback0[3] * durations2[1]) + (envelopeFeedback0[4] * durations2[1])), envelopeFeedback0[4] * durations2[1], (envelopeFeedback0[5].min(1)), 'sine');
	feedback0Env1 = EnvGen.kr(feedback0Envelope1, Select.kr(networkChooser0,[onsets2[1], networkOnsets2[1]]), 1);
	feedback0Envelope2 = Env.linen(envelopeFeedback0[6] * durations2[2], durations2[2] - ((envelopeFeedback0[6] * durations2[2]) + (envelopeFeedback0[7] * durations2[2])), envelopeFeedback0[7] * durations2[2], (envelopeFeedback0[8].min(1)), 'sine');
	feedback0Env2 = EnvGen.kr(feedback0Envelope2, Select.kr(networkChooser0,[onsets2[2], networkOnsets2[2]]), 1);
	feedback0Envelope3 = Env.linen(envelopeFeedback0[9] * durations2[3], durations2[3] - ((envelopeFeedback0[9] * durations2[3]) + (envelopeFeedback0[10] * durations2[3])), envelopeFeedback0[10] * durations2[3], (envelopeFeedback0[11].min(1)), 'sine');
	feedback0Env3 = EnvGen.kr(feedback0Envelope3, Select.kr(networkChooser0,[onsets2[3], networkOnsets2[3]]), 1);
	feedback0Envelope4 = Env.linen(envelopeFeedback0[12] * durations2[4], durations2[4] - ((envelopeFeedback0[12] * durations2[4]) + (envelopeFeedback0[13] * durations2[4])), envelopeFeedback0[13] * durations2[4], (envelopeFeedback0[14].min(1)), 'sine');
	feedback0Env4 = EnvGen.kr(feedback0Envelope4, Select.kr(networkChooser0,[onsets2[4], networkOnsets2[4]]), 1);
	feedback0Envelope5 = Env.linen(envelopeFeedback0[15] * durations2[5], durations2[5] - ((envelopeFeedback0[15] * durations2[5]) + (envelopeFeedback0[16] * durations2[5])), envelopeFeedback0[16] * durations2[5], (envelopeFeedback0[17].min(1)), 'sine');
	feedback0Env5 = EnvGen.kr(feedback0Envelope5, Select.kr(networkChooser0,[onsets2[5], networkOnsets2[5]]), 1);
	feedback0Envelope6 = Env.linen(envelopeFeedback0[18] * durations2[6], durations2[6] - ((envelopeFeedback0[18] * durations2[6]) + (envelopeFeedback0[19] * durations2[6])), envelopeFeedback0[19] * durations2[6], (envelopeFeedback0[20].min(1)), 'sine');
	feedback0Env6 = EnvGen.kr(feedback0Envelope6, Select.kr(networkChooser0,[onsets2[6], networkOnsets2[6]]), 1);
	feedback0Envelope7 = Env.linen(envelopeFeedback0[21] * durations2[7], durations2[7] - ((envelopeFeedback0[21] * durations2[7]) + (envelopeFeedback0[22] * durations2[7])), envelopeFeedback0[22] * durations2[7], (envelopeFeedback0[23].min(1)), 'sine');
	feedback0Env7 = EnvGen.kr(feedback0Envelope7, Select.kr(networkChooser0,[onsets2[7], networkOnsets2[7]]), 1);
	feedback0Envelope8 = Env.linen(envelopeFeedback0[24] * durations2[8], durations2[8] - ((envelopeFeedback0[24] * durations2[8]) + (envelopeFeedback0[25] * durations2[8])), envelopeFeedback0[25] * durations2[8], (envelopeFeedback0[26].min(1)), 'sine');
	feedback0Env8 = EnvGen.kr(feedback0Envelope8, Select.kr(networkChooser0,[onsets2[8], networkOnsets2[8]]), 1);
	feedback0Envelope9 = Env.linen(envelopeFeedback0[27] * durations2[9], durations2[9] - ((envelopeFeedback0[27] * durations2[9]) + (envelopeFeedback0[28] * durations2[9])), envelopeFeedback0[28] * durations2[9], (envelopeFeedback0[29].min(1)), 'sine');
	feedback0Env9 = EnvGen.kr(feedback0Envelope9, Select.kr(networkChooser0,[onsets2[9], networkOnsets2[9]]), 1);
	feedback0Envelope10 = Env.linen(envelopeFeedback0[30] * durations2[10], durations2[10] - ((envelopeFeedback0[30] * durations2[10]) + (envelopeFeedback0[31] * durations2[10])), envelopeFeedback0[1] * durations2[10], (envelopeFeedback0[32].min(1)), 'sine');
	feedback0Env10 = EnvGen.kr(feedback0Envelope10, Select.kr(networkChooser0,[onsets2[10], networkOnsets2[10]]), 1);
	feedback0Envelope11 = Env.linen(envelopeFeedback0[33] * durations2[11], durations2[11] - ((envelopeFeedback0[33] * durations2[11]) + (envelopeFeedback0[34] * durations2[11])), envelopeFeedback0[34] * durations2[11], (envelopeFeedback0[35].min(1)), 'sine');
	feedback0Env11 = EnvGen.kr(feedback0Envelope11, Select.kr(networkChooser0,[onsets2[11], networkOnsets2[11]]), 1);
	feedback0Envelope12 = Env.linen(envelopeFeedback0[36] * durations2[12], durations2[12] - ((envelopeFeedback0[36] * durations2[12]) + (envelopeFeedback0[37] * durations2[12])), envelopeFeedback0[37] * durations2[12], (envelopeFeedback0[38].min(1)), 'sine');
	feedback0Env12 = EnvGen.kr(feedback0Envelope12, Select.kr(networkChooser0,[onsets2[12], networkOnsets2[12]]), 1);

// create triggers for GUI for control source one
	osc0gate0 = Trig1.kr(Select.kr(networkChooser0,[onsets0[0], networkOnsets0[0]]), (0.1) );
	osc0gate1 = Trig1.kr(Select.kr(networkChooser0,[onsets0[1], networkOnsets0[1]]), (0.1) );
	osc0gate2 = Trig1.kr(Select.kr(networkChooser0,[onsets0[2], networkOnsets0[2]]), (0.1) );
	osc0gate3 = Trig1.kr(Select.kr(networkChooser0,[onsets0[3], networkOnsets0[3]]), (0.1) );
	osc0gate4 = Trig1.kr(Select.kr(networkChooser0,[onsets0[4], networkOnsets0[4]]), (0.1) );
	osc0gate5 = Trig1.kr(Select.kr(networkChooser0,[onsets0[5], networkOnsets0[5]]), (0.1) );
	osc0gate6 = Trig1.kr(Select.kr(networkChooser0,[onsets0[6], networkOnsets0[6]]), (0.1) );
	osc0gate7 = Trig1.kr(Select.kr(networkChooser0,[onsets0[7], networkOnsets0[7]]), (0.1) );
	osc0gate8 = Trig1.kr(Select.kr(networkChooser0,[onsets0[8], networkOnsets0[8]]), (0.1) );
	osc0gate9 = Trig1.kr(Select.kr(networkChooser0,[onsets0[9], networkOnsets0[9]]), (0.1) );
	osc0gate10 = Trig1.kr(Select.kr(networkChooser0,[onsets0[10], networkOnsets0[10]]), (0.1) );
	osc0gate11 = Trig1.kr(Select.kr(networkChooser0,[onsets0[11], networkOnsets0[11]]), (0.1) );
	osc0gate12 = Trig1.kr(Select.kr(networkChooser0,[onsets0[12], networkOnsets0[12]]), (0.1) );

// create triggers for GUI for control source two
	osc1gate0 = Trig1.kr(Select.kr(networkChooser0,[onsets1[0], networkOnsets1[0]]), (0.1) );
	osc1gate1 = Trig1.kr(Select.kr(networkChooser0,[onsets1[1], networkOnsets1[1]]), (0.1) );
	osc1gate2 = Trig1.kr(Select.kr(networkChooser0,[onsets1[2], networkOnsets1[2]]), (0.1) );
	osc1gate3 = Trig1.kr(Select.kr(networkChooser0,[onsets1[3], networkOnsets1[3]]), (0.1) );
	osc1gate4 = Trig1.kr(Select.kr(networkChooser0,[onsets1[4], networkOnsets1[4]]), (0.1) );
	osc1gate5 = Trig1.kr(Select.kr(networkChooser0,[onsets1[5], networkOnsets1[5]]), (0.1) );
	osc1gate6 = Trig1.kr(Select.kr(networkChooser0,[onsets1[6], networkOnsets1[6]]), (0.1) );
	osc1gate7 = Trig1.kr(Select.kr(networkChooser0,[onsets1[7], networkOnsets1[7]]), (0.1) );
	osc1gate8 = Trig1.kr(Select.kr(networkChooser0,[onsets1[8], networkOnsets1[8]]), (0.1) );
	osc1gate9 = Trig1.kr(Select.kr(networkChooser0,[onsets1[9], networkOnsets1[9]]), (0.1) );
	osc1gate10 = Trig1.kr(Select.kr(networkChooser0,[onsets1[10], networkOnsets1[10]]), (0.1) );
	osc1gate11 = Trig1.kr(Select.kr(networkChooser0,[onsets1[11], networkOnsets1[11]]), (0.1) );
	osc1gate12 = Trig1.kr(Select.kr(networkChooser0,[onsets1[12], networkOnsets1[12]]), (0.1) );

// create triggers for GUI for control source three
	feedbackGate0 = Trig1.kr(Select.kr(networkChooser0,[onsets2[0], networkOnsets2[0]]), (0.1) );
	feedbackGate1 = Trig1.kr(Select.kr(networkChooser0,[onsets2[1], networkOnsets2[1]]), (0.1) );
	feedbackGate2 = Trig1.kr(Select.kr(networkChooser0,[onsets2[2], networkOnsets2[2]]), (0.1) );
	feedbackGate3 = Trig1.kr(Select.kr(networkChooser0,[onsets2[3], networkOnsets2[3]]), (0.1) );
	feedbackGate4 = Trig1.kr(Select.kr(networkChooser0,[onsets2[4], networkOnsets2[4]]), (0.1) );
	feedbackGate5 = Trig1.kr(Select.kr(networkChooser0,[onsets2[5], networkOnsets2[5]]), (0.1) );
	feedbackGate6 = Trig1.kr(Select.kr(networkChooser0,[onsets2[6], networkOnsets2[6]]), (0.1) );
	feedbackGate7 = Trig1.kr(Select.kr(networkChooser0,[onsets2[7], networkOnsets2[7]]), (0.1) );
	feedbackGate8 = Trig1.kr(Select.kr(networkChooser0,[onsets2[8], networkOnsets2[8]]), (0.1) );
	feedbackGate9 = Trig1.kr(Select.kr(networkChooser0,[onsets2[9], networkOnsets2[9]]), (0.1) );
	feedbackGate10 = Trig1.kr(Select.kr(networkChooser0,[onsets2[10], networkOnsets2[10]]), (0.1) );
	feedbackGate11 = Trig1.kr(Select.kr(networkChooser0,[onsets2[11], networkOnsets2[11]]), (0.1) );
	feedbackGate12 = Trig1.kr(Select.kr(networkChooser0,[onsets2[12], networkOnsets2[12]]), (0.1) );

	envelopeArray0 = [onset0Env0, onset0Env1, onset0Env2, onset0Env3, onset0Env4, onset0Env5, onset0Env6, onset0Env7, onset0Env8, onset0Env9, onset0Env10, onset0Env11, onset0Env12];

	envelopeArray1 = [onset1Env0, onset1Env1, onset1Env2, onset1Env3, onset1Env4, onset1Env5, onset1Env6, onset1Env7, onset1Env8, onset1Env9, onset1Env10, onset1Env11, onset1Env12];

	guiEnvelopeArray0 = [grain0Attack0, grain0Release0, grain0Amplitude0, grain0Attack1, grain0Release1, grain0Amplitude1, grain0Attack2, grain0Release2, grain0Amplitude2, grain0Attack3, grain0Release3, grain0Amplitude3, grain0Attack4, grain0Release4, grain0Amplitude4, grain0Attack5, grain0Release5, grain0Amplitude5, grain0Attack6, grain0Release6, grain0Amplitude6, grain0Attack7, grain0Release7, grain0Amplitude7, grain0Attack8, grain0Release8, grain0Amplitude8, grain0Attack9, grain0Release9, grain0Amplitude9, grain0Attack10, grain0Release10, grain0Amplitude10, grain0Attack11, grain0Release11, grain0Amplitude11, grain0Attack12, grain0Release12, grain0Amplitude12];

	guiEnvelopeArray1 = [grain1Attack0, grain1Release0, grain1Amplitude0, grain1Attack1, grain1Release1, grain1Amplitude1, grain1Attack2, grain1Release2, grain1Amplitude2, grain1Attack3, grain1Release3, grain1Amplitude3, grain1Attack4, grain1Release4, grain1Amplitude4, grain1Attack5, grain1Release5, grain1Amplitude5, grain1Attack6, grain1Release6, grain1Amplitude6, grain1Attack7, grain1Release7, grain1Amplitude7, grain1Attack8, grain1Release8, grain1Amplitude8, grain1Attack9, grain1Release9, grain1Amplitude9, grain1Attack10, grain1Release10 , grain1Amplitude10, grain1Attack11, grain1Release11, grain1Amplitude11, grain1Attack12, grain1Release12, grain1Amplitude12];

	grainEnvelopeArray0 = [feedback0Env0, feedback0Env1, feedback0Env2, feedback0Env3, feedback0Env4, feedback0Env5, feedback0Env6, feedback0Env7, feedback0Env8, feedback0Env9, feedback0Env10, feedback0Env11, feedback0Env12];

	triggersArray0 = [osc0gate0, osc0gate1, osc0gate2, osc0gate3, osc0gate4, osc0gate5, osc0gate6, osc0gate7, osc0gate8, osc0gate9, osc0gate10, osc0gate11, osc0gate12];

	triggersArray1 = [osc1gate0, osc1gate1, osc1gate2, osc1gate3, osc1gate4, osc1gate5, osc1gate6, osc1gate7, osc1gate8, osc1gate9, osc1gate10, osc1gate11, osc1gate12];

	guiGateMix0 = [feedbackGate0, feedbackGate1, feedbackGate2, feedbackGate3, feedbackGate4, feedbackGate5, feedbackGate6, feedbackGate7, feedbackGate8, feedbackGate9, feedbackGate10, feedbackGate11, feedbackGate12];

// send triggers and envelopes to relevant control busses
	Out.kr(~grainGuiTriggerBus0, guiGateMix0);
	Out.kr(~envelopeBus0, envelopeArray0);
	Out.kr(~envelopeBus1, envelopeArray1);
	Out.kr(~envelopeBus2, grainEnvelopeArray0);
	Out.kr(~guiEnvelopeBus0, guiEnvelopeArray0);
	Out.kr(~guiEnvelopeBus1, guiEnvelopeArray1);
	Out.kr(~trigger0Bus0, triggersArray0);
	Out.kr(~trigger1Bus0, triggersArray1);

	}).send(s);

	~dataSelector0 = 0;
	~dataSelector1 = 0;

	//MFCC Data0 from control bus
	mfccData0 = Array.fill(13, 0 ,0);

	//MFCC Data1 from control bus
	mfccData1 = Array.fill(13, 0 ,0);

	//MFCC Data2 from control bus
	mfccData2 = Array.fill(13, 0 ,0);

	//Onset0 from control bus
	onset0Data0 = Array.fill(13, 0 ,0);

	//Onset1 from control bus
	onset1Data0 = Array.fill(13, 0 ,0);

	//duration0 from control bus
	duration0Data0 = Array.fill(13, 0 ,0);

	//duration1 from control bus
	duration1Data0 = Array.fill(13, 0 ,0);

	//duration2 from control bus
	duration2Data0 = Array.fill(13, 0 ,0);

	//pan0 from control bus
	pan0Data0 = Array.fill(13, 0 ,0);

	//pan1 from control bus
	pan1Data0 = Array.fill(13, 0 ,0);

	//pan1 from control bus
	pan2Data0 = Array.fill(13, 0 ,0);

	//Envelope0 from control bus
	envelope0Data0 = Array.fill(13, 0 ,0);

	//Get Envelope1 from control bus
	envelope1Data0 = Array.fill(13, 0 ,0);

	//Envelope2 from control bus
	envelope2Data0 = Array.fill(13, 0 ,0);

	//Envelope0 from control bus
	envelopeData0 = Array.fill(39, 0 ,0);

	//Envelope1 from control bus
	envelopeData1 = Array.fill(39, 0 ,0);

	//Pitch0 from control bus
	pitch0Data0 = Array.fill(13, 0 ,0);

	//Pitch1 from control bus
	pitch1Data0 = Array.fill(13, 0 ,0);

	//Pitch1 from control bus
	pitch2Data0 = Array.fill(13, 0 ,0);

	//Grain Position 0 from control bus
	position0Data0 = Array.fill(13, 0 ,0);

	//Grain Position 1 from control bus
	position1Data0 = Array.fill(13, 0 ,0);

	//Grain Position 2 from control bus
	position2Data0 = Array.fill(13, 0 ,0);

	//Freeze Data 0 from control bus
	freezeData0 =  Array.fill(13, 0 ,0);

	//Freeze Data 1 from control bus
	freezeData1 =  Array.fill(13, 0 ,0);

	//Freeze Data 2 from control bus
	freezeData2 =  Array.fill(13, 0 ,0);

	//Filter Freq Data 0 from control bus
	filterFreqData0 =  Array.fill(13, 0 ,0);

	//Filter Freq Data 1 from control bus
	filterFreqData1 =  Array.fill(13, 0 ,0);

	//Filter Freq Data 2 from control bus
	filterFreqData2 =  Array.fill(13, 0 ,0);


// set mappings for GUI objects
	~filterSpec0 = ControlSpec(40, 4000, \linear,1);
	~attackSpec0 = ControlSpec(0.05, 1,\linear,0.05);
	panSpec0 = ControlSpec(-1,1,\linear,0.01, 0);
	~volumeSpec0 = ControlSpec(0,1,\db,0.0001);
	~freezeSpec0 = ControlSpec(0,1,\linear,1);
	~thresholdSpec0 = ControlSpec(0,1,\linear,0.1);
	~pitch0spec0 = ControlSpec(0.1,4,\linear,0.1);
	~grainPitch0Spec0 = ControlSpec(-4,4,\linear,0.1);
	~meanSpec1 = ControlSpec(0.1, 100,\linear,0.1);
	~rate0Spec0 = ControlSpec(-2, 2,\linear, 0.01);
	~sampleRateSpec0 = ControlSpec(44, 0,\linear, 0.1);
	resSpec0 = ControlSpec(0.01, 1,\linear, 0.01);
	~adjusterSpec0 = ControlSpec(-2000, 2000,\linear, 0.01);
	~adjusterSpec1 = ControlSpec(0, 4000,\linear, 0.01);
	volume1Spec0 = ControlSpec(0, 1,\linear, 0.01);
	~envelopeMultiplierSpec0 = ControlSpec(0.01, 2,\linear, 0.01);
	~delaySpec1 = ControlSpec(0, 1,\linear, 0.01);
	~grainLengthSpec0 = ControlSpec(0.1, 0.5,\linear, 0.05);
	~durationSpec0 = ControlSpec(0.05, 4,\linear, 0.05);
	~micLevelSpec0 = ControlSpec(1, 20,\exp, 0.1);

	~networkSelector0 = 0;
	~filterOnValue0 = 0;
	~filterOnValue1 = 0;
	~filterOnValue2 = 0;
	~filterOnTrackingValue0 = 0;
	~filterOnTrackingValue1 = 0;
	~filterOnTrackingValue2 = 0;
	~pitchFix0 = 0;

// create windows for main GUI
	~w1 = Window("Genesis", Rect(0, 836, 1920, 320), false, true, scroll: true);
	~w7 = Window("", Rect(0, 686, 1920, 150), false, false, scroll: true);
	~w5 = Window("", Rect(((1920/6)*3), 0, (1920/2), 316), false, false, scroll: true);
	~w6 = Window("", Rect(((1920/6)*1.5), 0, (1920/4), 316), false, false, scroll: true);

	~w1.view.background_(Color.gray);
	~w5.view.background_(Color.gray);
	~w6.view.background_(Color.gray);
	~w7.view.background_(Color.gray);

	~w1.userCanClose = false;
	~w5.userCanClose = false;
	~w6.userCanClose = false;
	~w7.userCanClose = false;

// create 13 buttons displaying onsets of control one
	~tickButton0 = Array.new(13);
	~tickButton0Array0 = Array.fill(13, {arg i;
	~tickButton0.add(Button(~w7, Rect(0+(i*(1920/3)/13), 32, (1920/3)/20, 12.5)));
	~tickButton0[i].states_([
					["",Color.clear,Color.clear],
					["",Color.yellow.alpha_(0.5),Color.yellow.alpha_(0.7)],
							]);
	});

// create 13 buttons displaying onsets of control two
	~tickButton1 = Array.new(13);
	~tickButton1Array0 = Array.fill(13, {arg i;
	~tickButton1.add(Button(~w7, Rect((1920/6)*2 + (i*(1920/3)/13), 32, (1920/3)/20, 12.5)));
	~tickButton1[i].states_([
					["",Color.clear,Color.clear],
					["",Color.red.alpha_(0.5),Color.red.alpha_(0.7)],
							]);
	});

// create 13 buttons displaying onsets of control three/slave
	~tickButton2 = Array.new(13);
	~tickButton2Array0 = Array.fill(13, {arg i;
	~tickButton2.add(Button(~w7, Rect((1920/6)*4 +(i*(1920/3)/13), 32, (1920/3)/20, 12.5)));
	~tickButton2[i].states_([
					["",Color.clear,Color.clear],
					["",Color.blue.alpha_(0.5),Color.blue.alpha_(0.7)],
							]);
	});

// create array for text in GUI
	~attackText0 = Array.new(50);
	attackTextArray0 = Array.fill(50, {arg i;
	~attackText0.add();
	});

// DNA = number of audio files applied
	~attackText0[19] = StaticText(~w5, Rect(825, 200, 60, 50));
	~attackText0[19].font_(Font("Monaco", 18));
	~attackText0[19].string_("DNA0");
	~attackText0[19].stringColor_(Color.yellow);
	~attackText0[20] = StaticText(~w5, Rect(825, 230, 60, 50));
	~attackText0[20].font_(Font("Monaco", 18));
	~attackText0[20].string_("DNA1");
	~attackText0[20].stringColor_(Color.red);
	~attackText0[21] = StaticText(~w5, Rect(920, 200, 25, 50));
	~attackText0[21].font_(Font("Monaco", 18));
	~attackText0[21].string_("0");
	~attackText0[21].stringColor_(Color.yellow);
	~attackText0[22] = StaticText(~w5, Rect(920, 230, 25, 50));
	~attackText0[22].font_(Font("Monaco", 18));
	~attackText0[22].string_("0");
	~attackText0[22].stringColor_(Color.red);
	~attackText0[23] = StaticText(~w6, Rect(0, 0, 50, 25));
	~attackText0[27] = StaticText(~w5, Rect(733, 210, 100, 35));
	~attackText0[27].font_(Font("Monaco", 30));
	~attackText0[27].stringColor_(Color.black);

// Create button for displaying spectral denisty of control one
	~triggerButtonOn0 = Button(~w1, Rect((1280+25) + 195, 150,  50, 50));
	~triggerButtonOn0.states_([
					["",Color.gray,Color.gray],
					["",Color.yellow,Color.yellow],
							]);

// Create button for displaying spectral denisty of control two
	~triggerButtonOn1 = Button(~w1, Rect((1280+25) + 295, 150, 50, 50));
	~triggerButtonOn1.states_([
					["",Color.gray,Color.gray],
					["",Color.red,Color.red],
							]);

// Create button for displaying spectral denisty of control three
	~triggerButtonOn2 = Button(~w1, Rect((1280+25) + 395, 150, 50, 50));
	~triggerButtonOn2.states_([
					["",Color.gray,Color.gray],
					["",Color.blue,Color.blue],
							]);

// Slider for MFCCs of control one
	~oscData0Slider0 = MultiSliderView(~w1, Rect(26, 26, (1920/3)-50, height-78));
	~oscData0Slider0.value = Array.fill(13, 0, 0);
	~oscData0Slider0.fillColor_(Color.black.alpha_(0.5));
	~oscData0Slider0.strokeColor_(Color.black.alpha_(0.5));
	~oscData0Slider0.editable_(false);
	~oscData0Slider0.elasticMode_(1);
	~oscData0Slider0.drawLines_(true);
	~oscData0Slider0.thumbSize_(10);
	~oscData0Slider0.background_(Color.gray.alpha_(0.0));

// Slider for MFCCs of control two
	~oscData1Slider0 = MultiSliderView(~w1, Rect((640)+25, 26, (1920/3)-50, height-78));
	~oscData1Slider0.value = Array.fill(13, 0, 0);
	~oscData1Slider0.fillColor_(Color.black.alpha_(0.5));
	~oscData1Slider0.strokeColor_(Color.black.alpha_(0.5));
	~oscData1Slider0.editable_(false);
	~oscData1Slider0.elasticMode_(1);
	~oscData1Slider0.drawLines_(true);
	~oscData1Slider0.thumbSize_(10);
	~oscData1Slider0.background_(Color.gray.alpha_(0.0));

// Slider for MFCCs of control three
	~oscData2Slider0 = MultiSliderView(~w1, Rect(1280+25, 26, (1920/3)-50, height-78));
	~oscData2Slider0.value = Array.fill(13, 0, 0);
	~oscData2Slider0.fillColor_(Color.black.alpha_(0.5));
	~oscData2Slider0.strokeColor_(Color.black.alpha_(0.5));
	~oscData2Slider0.editable_(false);
	~oscData2Slider0.elasticMode_(1);
	~oscData2Slider0.drawLines_(true);
	~oscData2Slider0.thumbSize_(10);
	~oscData2Slider0.background_(Color.gray.alpha_(0.0));

// Display pitch of control one
	~pitchView0 = UserView(~w7, Rect(((1920/3)/4)*1.7, 40, 1920/12, 90));
	~pitchView0.drawFunc = {
			Pen.translate((1920/12)/2, 45);
			1.do{
				Pen.color = Color.yellow.alpha_(0.7);
				Pen.addWedge((5)@(5), ~pitchMessage0/48, 2pi, 2pi);
				Pen.perform(\fill);
			}
			};

// Display pitch of control two
	~pitchView1 = UserView(~w7, Rect(((1920/3)/4)*5.7, 40, 1920/12, 90));
	~pitchView1.drawFunc = {
			Pen.translate((1920/12)/2, 45);
			1.do{
				Pen.color = Color.red.alpha_(0.7);
				Pen.addWedge((5)@(5), ~pitchMessage1/48, 2pi, 2pi);
				Pen.perform(\fill);
			}
			};

// Display pitch of control three/slave
	~grainPitch0View0 = UserView(~w7, Rect(((1920/3)/4)*9.7, 40, 1920/12, 90));
	~grainPitch0View0.drawFunc = {
			Pen.translate((1920/12)/2, 45);
			1.do{
				Pen.color = Color.blue.alpha_(0.5);
				Pen.addWedge((5)@(5), ~grainPitch0Message0/48, 2pi, 2pi);
				Pen.perform(\fill);
			}
			};

// Display pitch pitch fixed slave
	~scaleViewer0 = UserView(~w5, Rect(0, 0, 1920/2, 300));
	~scaleViewer0.drawFunc = {
			Pen.translate(200, 225);
			1.do{
				Pen.color = Color.yellow.alpha_(0.9);
				Pen.addWedge((5)@(5), scaleMessage0/50, 2pi, 2pi);
				Pen.perform(\fill);
			}
			};

// Display difference in pitch between scale and output pitch
	~scaleViewer1 = UserView(~w5, Rect(0, 0, 1920/2, 300));
	~scaleViewer1.drawFunc = {
			Pen.translate(200, 225);
			1.do{
				Pen.color = Color.red.alpha_(0.75);
				Pen.addWedge((5)@(5), scaleMessage1/10, 2pi, 2pi);
				Pen.perform(\fill);
			}
			};

// create array of sliders displaying spectral following of control one
	~filterTrackerSlider0 = Array.new(13);
	~filterTrackerSlider0Array = Array.fill(13, {arg i;
	~filterTrackerSlider0.add(EZSlider(~w7, Rect(((5) + ((((1920/3))/26) * i)) , 48, (((1920/3)/2)/21), 100), nil, ~filterSpec0, initVal:400, unitWidth:0, numberWidth:0, labelHeight:0, layout:\vert, margin: m));
	~filterTrackerSlider0[i].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));
	});

// create array of sliders displaying spectral following of control two
	~filterTrackerSlider1 = Array.new(13);
	~filterTrackerSlider1Array = Array.fill(13, {arg i;
	~filterTrackerSlider1.add(EZSlider(~w7, Rect((((1920/3 + 5)) + ((((1920/3))/26) * i)) , 48, (((1920/3)/2)/21), 100), nil, ~filterSpec0, initVal:400, unitWidth:0, numberWidth:0, labelHeight:0, layout:\vert, margin: m));
	~filterTrackerSlider1[i].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));
		});

// create array of sliders displaying spectral following of control three/slave
	~filterTrackerSlider2 = Array.new(13);
	~filterTrackerSlider2Array = Array.fill(13, {arg i;
	~filterTrackerSlider2.add(EZSlider(~w7, Rect((((1920/3 + 3.5)*2) + ((((1920/3))/26) * i)) , 48, (((1920/3)/2)/21), 100), nil, ~filterSpec0, initVal:400, unitWidth:0, numberWidth:0, labelHeight:0, layout:\vert, margin: m));
	~filterTrackerSlider2[i].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));
	});

// create array of Buttons for Genetic Algorithm Execution
	~algorithmButton0 = Array.new(7);
	~algorithmButton0Array0 = Array.fill(7, {arg i;
	~algorithmButton0.add();
	});

// create array of sliders for Genetic Algorithm crossover
	~crossoverSlider0 = Array.new(6);
	~crossoverSlider0Array0 = Array.fill(6, {arg i;
	~crossoverSlider0.add();
	});

// create array of sliders for Genetic Algorithm mutation
	~mutationSlider0 = Array.new(6);
	~mutationSlider0Array0 = Array.fill(6, {arg i;
	~mutationSlider0.add();
	});

// create array for devolve to collect number of times each time GA is executed
	~mfccArrayOut = List[];
	~envelopeArrayOut = List[];
	~durationArrayOut = List[];
	~onsetArrayOut = List[];
	~panArrayOut = List[];
	~pitchArrayOut = List[];
	~allArrayOut = List[];

// data selector for GA parent one
	~dataChooserPopUp0 = PopUpMenu(~w5, Rect(825, 0, 115, 100));
	~dataChooserPopUp0.items = ["Breed Yellow", "Breed Blue"];
	~dataChooserPopUp0.background_(Color.yellow.alpha_(0.8));
	~dataChooserPopUp0.font_(Font("Monaco", 14));
	~dataChooserPopUp0.action = {arg menu;
			~dataSelector0 = menu.value;
			if(menu.value == 0,
			{~dataChooserPopUp0.background_(Color.yellow.alpha_(0.8)); ~dataChooserPopUp0.stringColor_(Color.black);},
			{~dataChooserPopUp0.background_(Color.blue.alpha_(0.8)); ~dataChooserPopUp0.stringColor_(Color.white);});
		if((~dataChooserPopUp0.value == 0) && (~dataChooserPopUp1.value == 0),
		{~attackText0[19].string_("DNA0"); ~attackText0[19].stringColor_(Color.yellow);
		~attackText0[21].string_(~dna0.size.asString); ~attackText0[21].stringColor_(Color.yellow);
		~attackText0[20].string_("DNA1"); ~attackText0[20].stringColor_(Color.red);
		~attackText0[22].string_(~dna1.size.asString); ~attackText0[22].stringColor_(Color.red);
		~w5.refresh},
		{nil});
		if((~dataChooserPopUp0.value == 1) && (~dataChooserPopUp1.value == 0),
		{~attackText0[19].string_("child"); ~attackText0[19].stringColor_(Color.blue);
		~attackText0[21].string_(~child.size.asString); ~attackText0[21].stringColor_(Color.blue);
		~attackText0[20].string_("DNA1"); ~attackText0[20].stringColor_(Color.red);
		~attackText0[22].string_(~dna1.size.asString); ~attackText0[22].stringColor_(Color.red);
		~w5.refresh},
		{nil});
		if((~dataChooserPopUp0.value == 1) && (~dataChooserPopUp1.value == 1),
		{~attackText0[19].string_("child"); ~attackText0[19].stringColor_(Color.blue);
		~attackText0[21].string_(~child.size.asString); ~attackText0[21].stringColor_(Color.blue);
		~attackText0[20].string_("child"); ~attackText0[20].stringColor_(Color.blue);
		~attackText0[22].string_(~child.size.asString); ~attackText0[22].stringColor_(Color.blue);
		~w5.refresh},
		{nil});
		if((~dataChooserPopUp0.value == 0) && (~dataChooserPopUp1.value == 1),
		{~attackText0[19].string_("DNA0"); ~attackText0[19].stringColor_(Color.yellow);
		~attackText0[21].string_(~dna0.size.asString); ~attackText0[21].stringColor_(Color.yellow);
		~attackText0[20].string_("child"); ~attackText0[20].stringColor_(Color.blue);
		~attackText0[22].string_(~child.size.asString); ~attackText0[22].stringColor_(Color.blue);
		~w5.refresh},
		{nil});

			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~dataChooserPopUp0.valueAction = " ++  ~dataChooserPopUp0.value.asString ++ "}.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);
	};

// data selector for GA parent two
	~dataChooserPopUp1 = PopUpMenu(~w5, Rect(825, 100, 115, 100));
	~dataChooserPopUp1.items = ["Breed Red", "Breed Blue"];
	~dataChooserPopUp1.background_(Color.red.alpha_(0.8));
	~dataChooserPopUp1.font_(Font("Monaco", 14));
	~dataChooserPopUp1.stringColor_(Color.white);
	~dataChooserPopUp1.action = {arg menu;
			~dataSelector1 = menu.value;
			if(menu.value == 0,
			{~dataChooserPopUp1.background_(Color.red.alpha_(0.8)); ~dataChooserPopUp1.stringColor_(Color.white);},
			{~dataChooserPopUp1.background_(Color.blue.alpha_(0.8)); ~dataChooserPopUp1.stringColor_(Color.white);});
		if((~dataChooserPopUp0.value == 0) && (~dataChooserPopUp1.value == 0),
		{~attackText0[19].string_("DNA0"); ~attackText0[19].stringColor_(Color.yellow);
		~attackText0[21].string_(~dna0.size.asString); ~attackText0[21].stringColor_(Color.yellow);
		~attackText0[20].string_("DNA1"); ~attackText0[20].stringColor_(Color.red);
		~attackText0[22].string_(~dna1.size.asString); ~attackText0[22].stringColor_(Color.red);
		~w5.refresh},
		{nil});
		if((~dataChooserPopUp0.value == 1) && (~dataChooserPopUp1.value == 0),
		{~attackText0[19].string_("child"); ~attackText0[19].stringColor_(Color.blue);
		~attackText0[21].string_(~child.size.asString); ~attackText0[21].stringColor_(Color.blue);
		~attackText0[20].string_("DNA1"); ~attackText0[20].stringColor_(Color.red);
		~attackText0[22].string_(~dna1.size.asString); ~attackText0[22].stringColor_(Color.red);
		~w5.refresh},
		{nil});
		if((~dataChooserPopUp0.value == 1) && (~dataChooserPopUp1.value == 1),
		{~attackText0[19].string_("child"); ~attackText0[19].stringColor_(Color.blue);
		~attackText0[21].string_(~child.size.asString); ~attackText0[21].stringColor_(Color.blue);
		~attackText0[20].string_("child"); ~attackText0[20].stringColor_(Color.blue);
		~attackText0[22].string_(~child.size.asString); ~attackText0[22].stringColor_(Color.blue);
		~w5.refresh},
		{nil});
		if((~dataChooserPopUp0.value == 0) && (~dataChooserPopUp1.value == 1),
		{~attackText0[19].string_("DNA0"); ~attackText0[19].stringColor_(Color.yellow);
		~attackText0[21].string_(~dna0.size.asString); ~attackText0[21].stringColor_(Color.yellow);
		~attackText0[20].string_("child"); ~attackText0[20].stringColor_(Color.blue);
		~attackText0[22].string_(~child.size.asString); ~attackText0[22].stringColor_(Color.blue);
		~w5.refresh},
		{nil});
			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~dataChooserPopUp1.valueAction = " ++  ~dataChooserPopUp1.value.asString ++ "}.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);
	};

	~rev0 = 0;
	~rev1 = 0;
	~rev2 = 0;
	~rev3 = 0;
	~rev4 = 0;
	~rev5 = 0;
	~rev6 = 0;

// Devolve button for MFCC
	~revButton0 = Array.new(7);
	~revButtonArray0 = Array.fill(7, {arg i;
	~revButton0.add();
	});

	~revButton0[0] = Button(~w5, Rect(600, 0, 100, 25));
	~revButton0[0].states_([["Devolve", Color.white, Color.blue.alpha_(0.4)]]);
	~revButton0[0].font_(Font("Monaco", 10));
	~revButton0[0].action_({
			mfccReverseBreed = Object.readArchive(PathName.tmp ++ "MFCCARRAY");
			mfccBreed = mfccReverseBreed[~rev0].asArray;
			~trackerSynth2.set(\mfccFeedback, mfccBreed);
			~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Spectrum Devolved " ++ ~revChooserPop0[0].value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~revButton0[0].valueAction = 1 }.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);
	});

// Devolve button for Envelope
	~revButton0[1] = Button(~w5, Rect(600, 37.5, 100, 25));
	~revButton0[1].states_([["Devolve", Color.white, Color.blue.alpha_(0.5)]]);
	~revButton0[1].font_(Font("Monaco", 10));
	~revButton0[1].action_({
			envelopeReverseBreed = Object.readArchive(PathName.tmp ++ "ENVELOPEARRAY");
			envelopeBreed = envelopeReverseBreed[~rev1].asArray;
			~envelopeSynth.set(\envelopeFeedback0, envelopeBreed);
			~granularMacroSynth2.set(\envelopeFeedback0, envelopeBreed);

		~grainAttack2Slider.value_([envelopeBreed[0], envelopeBreed[3], envelopeBreed[6], envelopeBreed[9], envelopeBreed[12], envelopeBreed[15], envelopeBreed[18], envelopeBreed[21], envelopeBreed[24], envelopeBreed[27], envelopeBreed[30], envelopeBreed[33], envelopeBreed[36]]/2);

		~grainRelease2Slider.value_([envelopeBreed[1], envelopeBreed[4], envelopeBreed[7], envelopeBreed[10], envelopeBreed[13], envelopeBreed[16], envelopeBreed[19], envelopeBreed[22], envelopeBreed[25], envelopeBreed[28], envelopeBreed[31], envelopeBreed[34], envelopeBreed[37]]/2);

		~grainAmplitude2Slider.value_([envelopeBreed[2], envelopeBreed[5], envelopeBreed[8], envelopeBreed[11], envelopeBreed[14], envelopeBreed[17], envelopeBreed[20], envelopeBreed[23], envelopeBreed[26], envelopeBreed[29], envelopeBreed[32], envelopeBreed[35], envelopeBreed[38]]);

			~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Envelope Devolved " ++ ~revChooserPop0[1].value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~revButton0[1].valueAction = 1 }.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);

	});

// Devolve button for Duration
	~revButton0[2] = Button(~w5, Rect(600, 75, 100, 25));
	~revButton0[2].states_([["Devolve", Color.white, Color.blue.alpha_(0.6)]]);
	~revButton0[2].font_(Font("Monaco", 10));
	~revButton0[2].action_({
			durationReverseBreed0 = Object.readArchive(PathName.tmp ++ "DURATIONARRAY");
			duration0Breed0 = durationReverseBreed0[~rev2].asArray;
			~granularMacroSynth2.set(\onsetDuration2Array0, duration0Breed0.min(2));
			~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Duration Devolved " ++ ~revChooserPop0[2].value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
			~feedbackDurationSlider0.value_((duration0Breed0.min(2))/4);
			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~revButton0[2].valueAction = 1 }.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);
	});

// Devolve button for Thresholds
	~revButton0[3] = Button(~w5, Rect(600, 112.5, 100, 25));
	~revButton0[3].states_([["Devolve", Color.white, Color.blue.alpha_(0.7)]]);
	~revButton0[3].font_(Font("Monaco", 10));
	~revButton0[3].mouseDownAction_({
				onsetReverseBreed0 = Object.readArchive(PathName.tmp ++ "ONSETARRAY");
				onset0Breed0 = onsetReverseBreed0[~rev3].asArray;
				~analysisSynth.set(\onsetFeedback0, onset0Breed0);
		~onsetThresholdSlider2.value_(~thresholdSpec0.map(onset0Breed0));

			~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Threshold Devolved " ++ ~revChooserPop0[3].value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~revButton0[3].valueAction = 1 }.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);

	});

// Devolve button for Pan
	~revButton0[4] = Button(~w5, Rect(600, 150, 100, 25));
	~revButton0[4].states_([["Devolve", Color.white, Color.blue.alpha_(0.8)]]);
	~revButton0[4].font_(Font("Monaco", 10));
	~revButton0[4].action_({
			panReverseBreed0 = Object.readArchive(PathName.tmp ++ "PANARRAY");
			pan0Breed0 = panReverseBreed0[~rev4].asArray;
			~pan2Synth.set(\grain2PanArray0, pan0Breed0);

			~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Pan Devolved " ++ ~revChooserPop0[4].value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);

		~panKnob2[0].value_(\pan.asSpec.unmap(pan0Breed0[0]));
		~panKnob2[1].value_(\pan.asSpec.unmap(pan0Breed0[1]));
		~panKnob2[2].value_(\pan.asSpec.unmap(pan0Breed0[2]));
		~panKnob2[3].value_(\pan.asSpec.unmap(pan0Breed0[3]));
		~panKnob2[4].value_(\pan.asSpec.unmap(pan0Breed0[4]));
		~panKnob2[5].value_(\pan.asSpec.unmap(pan0Breed0[5]));
		~panKnob2[6].value_(\pan.asSpec.unmap(pan0Breed0[6]));
		~panKnob2[7].value_(\pan.asSpec.unmap(pan0Breed0[7]));
		~panKnob2[8].value_(\pan.asSpec.unmap(pan0Breed0[8]));
		~panKnob2[9].value_(\pan.asSpec.unmap(pan0Breed0[9]));
		~panKnob2[10].value_(\pan.asSpec.unmap(pan0Breed0[10]));
		~panKnob2[11].value_(\pan.asSpec.unmap(pan0Breed0[11]));
		~panKnob2[12].value_(\pan.asSpec.unmap(pan0Breed0[12]));

			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~revButton0[4].valueAction = 1 }.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);
	});

// Devolve button for Playback rate
	~revButton0[5] = Button(~w5, Rect(600, 187.5, 100, 25));
	~revButton0[5].states_([["Devolve", Color.white, Color.blue.alpha_(0.9)]]);
	~revButton0[5].font_(Font("Monaco", 10));
	~revButton0[5].action_({
			pitchReverseBreed0 = Object.readArchive(PathName.tmp ++ "PITCHARRAY");
			pitch0Breed0 = pitchReverseBreed0[~rev5].asArray;
			~pitch2Slider0.value_((pitch0Breed0+4)/8);
			~granularMacroSynth2.set(\pitchArray0, pitch0Breed0);
			~decimateSynth2.set(\pitchArray0, pitch0Breed0);
			~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Pitch Devolved " ++ ~revChooserPop0[5].value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~revButton0[5].valueAction = 1 }.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);

	});

// Devolve button for All
	~revButton0[6] = Button(~w5, Rect(600, 225, 100, 25));
	~revButton0[6].states_([["Devolve", Color.white, Color.blue.alpha_(1)]]);
	~revButton0[6].font_(Font("Monaco", 10));
	~revButton0[6].action_({
			mfccReverseBreed = Object.readArchive(PathName.tmp ++ "MFCCARRAY");
			mfccBreed = mfccReverseBreed[~rev6].asArray;
			~trackerSynth2.set(\mfccFeedback, mfccBreed);
			envelopeReverseBreed = Object.readArchive(PathName.tmp ++ "ENVELOPEARRAY");
			envelopeBreed = envelopeReverseBreed[~rev6].asArray;
			~envelopeSynth.set(\envelopeFeedback0, envelopeBreed);
			~granularMacroSynth2.set(\envelopeFeedback0, envelopeBreed);

		~grainAttack2Slider.value_([envelopeBreed[0], envelopeBreed[3], envelopeBreed[6], envelopeBreed[9], envelopeBreed[12], envelopeBreed[15], envelopeBreed[18], envelopeBreed[21], envelopeBreed[24], envelopeBreed[27], envelopeBreed[30], envelopeBreed[33], envelopeBreed[36]]/2);

		~grainRelease2Slider.value_([envelopeBreed[1], envelopeBreed[4], envelopeBreed[7], envelopeBreed[10], envelopeBreed[13], envelopeBreed[16], envelopeBreed[19], envelopeBreed[22], envelopeBreed[25], envelopeBreed[28], envelopeBreed[31], envelopeBreed[34], envelopeBreed[37]]/2);

		~grainAmplitude2Slider.value_([envelopeBreed[2], envelopeBreed[5], envelopeBreed[8], envelopeBreed[11], envelopeBreed[14], envelopeBreed[17], envelopeBreed[20], envelopeBreed[23], envelopeBreed[26], envelopeBreed[29], envelopeBreed[32], envelopeBreed[35], envelopeBreed[38]]);

			durationReverseBreed0 = Object.readArchive(PathName.tmp ++ "DURATIONARRAY");
			duration0Breed0 = durationReverseBreed0[~rev6].asArray;
			~granularMacroSynth2.set(\onsetDuration2Array0, duration0Breed0.min(2));

		~feedbackDurationSlider0.value_((duration0Breed0.min(2))/4);

			onsetReverseBreed0 = Object.readArchive(PathName.tmp ++ "ONSETARRAY");
			onset0Breed0 = onsetReverseBreed0[~rev6].asArray;
			~analysisSynth.set(\onsetFeedback0, onset0Breed0);
		~onsetThresholdSlider2.value_(~thresholdSpec0.map(onset0Breed0));

			panReverseBreed0 = Object.readArchive(PathName.tmp ++ "PANARRAY");
			pan0Breed0 = panReverseBreed0[~rev6].asArray;
			~pan2Synth.set(\grain2PanArray0, pan0Breed0);
		~panKnob2[0].value_(\pan.asSpec.unmap(pan0Breed0[0]));
		~panKnob2[1].value_(\pan.asSpec.unmap(pan0Breed0[1]));
		~panKnob2[2].value_(\pan.asSpec.unmap(pan0Breed0[2]));
		~panKnob2[3].value_(\pan.asSpec.unmap(pan0Breed0[3]));
		~panKnob2[4].value_(\pan.asSpec.unmap(pan0Breed0[4]));
		~panKnob2[5].value_(\pan.asSpec.unmap(pan0Breed0[5]));
		~panKnob2[6].value_(\pan.asSpec.unmap(pan0Breed0[6]));
		~panKnob2[7].value_(\pan.asSpec.unmap(pan0Breed0[7]));
		~panKnob2[8].value_(\pan.asSpec.unmap(pan0Breed0[8]));
		~panKnob2[9].value_(\pan.asSpec.unmap(pan0Breed0[9]));
		~panKnob2[10].value_(\pan.asSpec.unmap(pan0Breed0[10]));
		~panKnob2[11].value_(\pan.asSpec.unmap(pan0Breed0[11]));
		~panKnob2[12].value_(\pan.asSpec.unmap(pan0Breed0[12]));
			pitchReverseBreed0 = Object.readArchive(PathName.tmp ++ "PITCHARRAY");
			pitch0Breed0 = pitchReverseBreed0[~rev6].asArray;
			~granularMacroSynth2.set(\pitchArray0, pitch0Breed0);
			~decimateSynth2.set(\pitchArray0, pitch0Breed0);
			~pitch2Slider0.value_((pitch0Breed0+4)/8);

			~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " All Devolved " ++ ~revChooserPop0[6].value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~revButton0[6].valueAction = 1 }.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);

	});

// Create Array of PopUp menus for Devolve selector
	~revChooserPop0 = Array.new(7);
	~revChooserArray0 = Array.fill(7, {arg i;
	~revChooserPop0.add();
	});

// Select Devolve value for MFCC
	~revChooserPop0[0] = PopUpMenu(~w5, Rect(700, 0, 100, 25));
	~revChooserPop0[0].font_(Font("Monaco", 10));
	~revChooserPop0[0].action = {arg menu;
			~rev0 = menu.value;
			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~revChooserPop0[0].valueAction = " ++  ~revChooserPop0[0].value.asString ++ "}.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);
	};

// Select Devolve value for Envelope
	~revChooserPop0[1] = PopUpMenu(~w5, Rect(700, 37.5, 100, 25));
	~revChooserPop0[1].font_(Font("Monaco", 10));
	~revChooserPop0[1].action = {arg menu;
			~rev1 = menu.value;
			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~revChooserPop0[1].valueAction = " ++  ~revChooserPop0[0].value.asString ++ "}.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);
	};

// Select Devolve value for Duration
	~revChooserPop0[2] = PopUpMenu(~w5, Rect(700, 75, 100, 25));
	~revChooserPop0[2].font_(Font("Monaco", 10));
	~revChooserPop0[2].action = {arg menu;
			~rev2 = menu.value;
			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~revChooserPop0[2].valueAction = " ++  ~revChooserPop0[0].value.asString ++ "}.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);
	};

// Select Devolve value for Threshold
	~revChooserPop0[3] = PopUpMenu(~w5, Rect(700, 112.5, 100, 25));
	~revChooserPop0[3].font_(Font("Monaco", 10));
	~revChooserPop0[3].action = {arg menu;
			~rev3 = menu.value;
			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~revChooserPop0[3].valueAction = " ++  ~revChooserPop0[0].value.asString ++ "}.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);
	};

// Select Devolve value for Pan
	~revChooserPop0[4] = PopUpMenu(~w5, Rect(700, 150, 100, 25));
	~revChooserPop0[4].font_(Font("Monaco", 10));
	~revChooserPop0[4].action = {arg menu;
			~rev4 = menu.value;
			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~revChooserPop0[4].valueAction = " ++  ~revChooserPop0[0].value.asString ++ "}.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);
	};

// Select Devolve value for Playback Rate
	~revChooserPop0[5] = PopUpMenu(~w5, Rect(700, 187.5, 100, 25));
	~revChooserPop0[5].font_(Font("Monaco", 10));
	~revChooserPop0[5].action = {arg menu;
			~rev5 = menu.value;
			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~revChooserPop0[5].valueAction = " ++  ~revChooserPop0[0].value.asString ++ "}.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);
	};

// Select Devolve value for All
	~revChooserPop0[6] = PopUpMenu(~w5, Rect(700, 225, 100, 25));
	~revChooserPop0[6].font_(Font("Monaco", 10));
	~revChooserPop0[6].action = {arg menu;
			~revChooserPop0[0].value_(menu.value);
			~revChooserPop0[1].value_(menu.value);
			~revChooserPop0[2].value_(menu.value);
			~revChooserPop0[3].value_(menu.value);
			~revChooserPop0[4].value_(menu.value);
			~revChooserPop0[5].value_(menu.value);
			~rev6 = menu.value;
			~saveText.string_(" \n\n " " if(
			~clockGUI == " ++ ~clockGUI ++  "," ++
			"{{ ~revChooserPop0[6].valueAction = " ++  ~revChooserPop0[0].value.asString ++ "}.defer;}); ",
			(~saveText.string.size), (~saveText.string.size));
			~saveText.selectLine(~saveText.string.size);
	};

// Crossover Slider for MFCC
	~crossoverSlider0[0] = EZSlider(~w5, Rect(300, 25, 233, 12.5), "crossover", 	~volumeSpec0, unitWidth:30, initVal:0.1,numberWidth:30, layout:\horz);
	~crossoverSlider0[0].font_(Font("Monaco", 10));
	~crossoverSlider0[0].setColors(Color.clear,Color.white.alpha_(0.7));

	~crossoverSlider0[0].action_({ |ez|
								crossover0 = ez.value;
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " Spectrum Crossover  = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~crossoverSlider0[0].valueAction = " ++ ~crossoverSlider0[0].value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
								});

// Mutation Slider for MFCC
	~mutationSlider0[0] = EZSlider(~w5, Rect(500, 25, 233, 12.5), "mutation", 	~volumeSpec0, unitWidth:30, numberWidth:30, initVal:0.1,layout:\horz);
	~mutationSlider0[0].font_(Font("Monaco", 10));
	~mutationSlider0[0].setColors(Color.clear,Color.white.alpha_(0.7));
	~mutationSlider0[0].action_({|ez|
								mutation0 = ez.value;
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " Spectrum Mutation  = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~mutationSlider0[0].valueAction = " ++ ~mutationSlider0[0].value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
								});

// Execution button for MFCC GA; Mutation = 0 -- 2000
	~algorithmButton0[0] = Button(~w5, Rect(300, 0, 100, 25));
	~algorithmButton0[0].states_([["Spectrum", Color.white, Color.blue.alpha_(0.4)]]);
	~algorithmButton0[0].font_(Font("Monaco", 10));
	~algorithmButton0[0].action_({|butt|
	if(butt.value == 0,
	{
	RedGA.mutationFunc = {rrand(0, 2000);};
	mfccGenomeA = RedGAGenome.new(~mfccDataSelector0);
	mfccGenomeB = RedGAGenome.new(~mfccDataSelector1);
	RedGA.crossOverRate = crossover0;
	mfccCrossover = RedGA.breedMultiPoint(mfccGenomeA, mfccGenomeB);
	mfccCrossover.do{|x| x.chromosome};
	RedGA.mutationRate = mutation0;
	mfccBreed = RedGA.mutate(mfccCrossover[0]).chromosome;
	~trackerSynth2.set(\mfccFeedback, mfccBreed);
	~mfccArrayOut.addFirst(mfccBreed.max(0.005));
	~mfccArrayOut.asArray.writeArchive(PathName.tmp ++ "MFCCARRAY");
	~revChooserPop0[0].items = Array.fill(~mfccArrayOut.size, {arg i; i.asString});
			~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Spectrum Evolved ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~algorithmButton0[0].valueAction = 1 }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	});
	});

// Crossover Slider for Envelope
	~crossoverSlider0[1] = EZSlider(~w5, Rect(300, 62.5, 233, 12.5), "crossover", 		~volumeSpec0, unitWidth:30, initVal:0.1,numberWidth:30, layout:\horz);
	~crossoverSlider0[1].font_(Font("Monaco", 10));
	~crossoverSlider0[1].setColors(Color.clear,Color.white.alpha_(0.7));
	~crossoverSlider0[1].action_({|ez|
								crossover1 = ez.value;
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " Envelope Crossover  = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~crossoverSlider0[1].valueAction = " ++ ~crossoverSlider0[1].value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							});

// Mutation Slider for Envelope
	~mutationSlider0[1] = EZSlider(~w5, Rect(500, 62.5, 233, 12.5), "mutation", 	~volumeSpec0, unitWidth:30, initVal:0.1,numberWidth:30, layout:\horz);
	~mutationSlider0[1].font_(Font("Monaco", 10));
	~mutationSlider0[1].setColors(Color.clear,Color.white.alpha_(0.7));
	~mutationSlider0[1].action_({|ez|
								mutation1 = ez.value;
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " Envelope Mutation  = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~mutationSlider0[1].valueAction = " ++ ~mutationSlider0[1].value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);															});

// Execution button for Envelope GA; Mutation = 0.01 -- 2
	~algorithmButton0[1] = Button(~w5, Rect(300, 37.5, 100, 25));
	~algorithmButton0[1].states_([["Envelope", Color.white, Color.blue.alpha_(0.5)]]);
	~algorithmButton0[1].font_(Font("Monaco", 10));
	~algorithmButton0[1].action_({
	RedGA.mutationFunc = {rrand(0.01, 2.00);};
	envelopeGenomeA = RedGAGenome.new(~envelopeDataSelector0);
	envelopeGenomeB = RedGAGenome.new(~envelopeDataSelector1);
	RedGA.crossOverRate = crossover1;
	envelopeCrossover = RedGA.breedMultiPoint(envelopeGenomeA, envelopeGenomeB);
	envelopeCrossover.do{|x| x.chromosome};
	RedGA.mutationRate = mutation1;
	envelopeBreed = RedGA.mutate(envelopeCrossover[0]).chromosome;
	~envelopeSynth.set(\envelopeFeedback0, envelopeBreed);
	~granularMacroSynth2.set(\envelopeFeedback0, envelopeBreed);

	~envelopeArrayOut.addFirst(envelopeBreed);
		~grainAttack2Slider.value_([envelopeBreed[0], envelopeBreed[3], envelopeBreed[6], envelopeBreed[9], envelopeBreed[12], envelopeBreed[15], envelopeBreed[18], envelopeBreed[21], envelopeBreed[24], envelopeBreed[27], envelopeBreed[30], envelopeBreed[33], envelopeBreed[36]]/2);

		~grainRelease2Slider.value_([envelopeBreed[1], envelopeBreed[4], envelopeBreed[7], envelopeBreed[10], envelopeBreed[13], envelopeBreed[16], envelopeBreed[19], envelopeBreed[22], envelopeBreed[25], envelopeBreed[28], envelopeBreed[31], envelopeBreed[34], envelopeBreed[37]]/2);

		~grainAmplitude2Slider.value_([envelopeBreed[2], envelopeBreed[5], envelopeBreed[8], envelopeBreed[11], envelopeBreed[14], envelopeBreed[17], envelopeBreed[20], envelopeBreed[23], envelopeBreed[26], envelopeBreed[29], envelopeBreed[32], envelopeBreed[35], envelopeBreed[38]]);

	~envelopeArrayOut.asArray.writeArchive(PathName.tmp ++ "ENVELOPEARRAY");
	~revChooserPop0[1].items = Array.fill(~envelopeArrayOut.size, {arg i; i.asString});
			~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Envelope Evolved ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
			~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~algorithmButton0[1].valueAction = 1 }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	});

// Crossover Slider for Duration
	~crossoverSlider0[2] = EZSlider(~w5, Rect(300, 100, 233, 12.5), "crossover", 		~volumeSpec0, unitWidth:30, initVal:0.1, numberWidth:30, layout:\horz);
	~crossoverSlider0[2].font_(Font("Monaco", 10));
	~crossoverSlider0[2].setColors(Color.clear,Color.white.alpha_(0.7));
	~crossoverSlider0[2].action_({|ez|
								duration0CrossoverRate0 = ez.value;
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " Duration Crossover  = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~crossoverSlider0[2].valueAction = " ++ ~crossoverSlider0[2].value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);															});

// Mutation Slider for Duration
	~mutationSlider0[2] = EZSlider(~w5, Rect(500, 100, 233, 12.5), "mutation", 	~volumeSpec0, unitWidth:30, initVal:0.1, numberWidth:30, layout:\horz);
	~mutationSlider0[2].font_(Font("Monaco", 10));
	~mutationSlider0[2].setColors(Color.clear,Color.white.alpha_(0.7));
	~mutationSlider0[2].action_({|ez|
								duration0Mutation0 = ez.value;
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " Duration Mutation  = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~mutationSlider0[2].valueAction = " ++ ~mutationSlider0[2].value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);															});

// Execution button for Duration GA; Mutation = 0.01 -- 4
	~algorithmButton0[2] = Button(~w5, Rect(300, 75, 100, 25));
	~algorithmButton0[2].states_([["Duration", Color.white, Color.blue.alpha_(0.6)]]);
	~algorithmButton0[2].font_(Font("Monaco", 10));
	~algorithmButton0[2].action_({
	RedGA.mutationFunc = {rrand(0.01, 4.00);};
	duration0GenomeA = RedGAGenome.new(~durationDataSelector0);
	duration0GenomeB = RedGAGenome.new(~durationDataSelector1);
	RedGA.crossOverRate = duration0CrossoverRate0;
	duration0Crossover0 = RedGA.breedMultiPoint(duration0GenomeA, duration0GenomeB);
	duration0Crossover0.do{|x| x.chromosome};
	RedGA.mutationRate = duration0Mutation0;
	duration0Breed0 = RedGA.mutate(duration0Crossover0[0]).chromosome;
	~granularMacroSynth2.set(\onsetDuration2Array0, duration0Breed0.min(2));
	~feedbackDurationSlider0.value_((duration0Breed0.min(2))/4);
	~durationArrayOut.addFirst(duration0Breed0.min(2));
	~durationArrayOut.asArray.writeArchive(PathName.tmp ++ "DURATIONARRAY");
	~revChooserPop0[2].items = Array.fill(~durationArrayOut.size, {arg i; i.asString});

	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Duration Evolved ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~algorithmButton0[2].valueAction = 1 }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);

	});

// Crossover Slider for Threshold
	~crossoverSlider0[3] = EZSlider(~w5, Rect(300, 137.5, 233, 12.5), "crossover", 	~volumeSpec0, initVal:0.1, unitWidth:30, numberWidth:30, layout:\horz);
	~crossoverSlider0[3].font_(Font("Monaco", 10));
	~crossoverSlider0[3].setColors(Color.clear,Color.white.alpha_(0.7));
	~crossoverSlider0[3].action_({|ez|
								onset0CrossoverRate0 = ~crossoverSlider0[3].value;
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " Threshold Crossover  = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~crossoverSlider0[3].valueAction = " ++ ~crossoverSlider0[3].value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
								});

// Mutation Slider for Threshold
	~mutationSlider0[3] = EZSlider(~w5, Rect(500, 137.5, 233, 12.5), "mutation", 	~volumeSpec0, initVal:0.1, unitWidth:30, numberWidth:30, layout:\horz);
	~mutationSlider0[3].font_(Font("Monaco", 10));
	~mutationSlider0[3].setColors(Color.clear,Color.white.alpha_(0.7));
	~mutationSlider0[3].action_({|ez|
								onset0Mutation0 = ~mutationSlider0[3].value;
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " Threshold Mutation  = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~mutationSlider0[3].valueAction = " ++ ~mutationSlider0[3].value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
								});

// Execution button for Threshold GA; Mutation = 0 -- 1
	~algorithmButton0[3] = Button(~w5, Rect(300, 112.5, 100, 25));
	~algorithmButton0[3].states_([["Threshold", Color.white, Color.blue.alpha_(0.7)]]);
	~algorithmButton0[3].font_(Font("Monaco", 10));
	~algorithmButton0[3].action_({
	RedGA.mutationFunc = {rrand(0.0, 1.0);};
	onset0GenomeA = RedGAGenome.new(~onsetDataSelector0);
	onset0GenomeB = RedGAGenome.new(~onsetDataSelector1);
	RedGA.crossOverRate = onset0CrossoverRate0;
	onset0Crossover0 = RedGA.breedMultiPoint(onset0GenomeA, onset0GenomeB);
	onset0Crossover0.do{|x| x.chromosome};
	RedGA.mutationRate = onset0Mutation0;
	onset0Breed0 = RedGA.mutate(onset0Crossover0[0]).chromosome;
	~analysisSynth.set(\onsetFeedback0, onset0Breed0);
		~onsetThresholdSlider2.value_(~thresholdSpec0.map(onset0Breed0));
	~onsetArrayOut.addFirst(onset0Breed0);
	~onsetArrayOut.asArray.writeArchive(PathName.tmp ++ "ONSETARRAY");
	~revChooserPop0[3].items = Array.fill(~onsetArrayOut.size, {arg i; i.asString});

	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Threshold Evolved ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~algorithmButton0[3].valueAction = 1 }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	});

// Crossover Slider for Pan
	~crossoverSlider0[4] = EZSlider(~w5, Rect(300, 175.5, 233, 12.5), "crossover", 		~volumeSpec0, initVal:0.1,unitWidth:30, numberWidth:30, layout:\horz);
	~crossoverSlider0[4].font_(Font("Monaco", 10));
	~crossoverSlider0[4].setColors(Color.clear,Color.white.alpha_(0.7));
	~crossoverSlider0[4].action_({|ez|
								pan0CrossoverRate0 = ez.value;
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " Pan Crossover  = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~crossoverSlider0[4].valueAction = " ++ ~crossoverSlider0[4].value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);																});

// Mutation Slider for Pan
	~mutationSlider0[4] = EZSlider(~w5, Rect(500, 175.5, 233, 12.5), "mutation", 	~volumeSpec0, unitWidth:30, initVal:0.1,numberWidth:30, layout:\horz);
	~mutationSlider0[4].font_(Font("Monaco", 10));
	~mutationSlider0[4].setColors(Color.clear,Color.white.alpha_(0.7));
	~mutationSlider0[4].action_({|ez|
								pan0Mutation0 = ez.value;
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " Pan Mutation  = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~mutationSlider0[4].valueAction = " ++ ~mutationSlider0[4].value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);									});

// Execution button for Pan GA; Mutation = -1 -- 1
	~algorithmButton0[4] = Button(~w5, Rect(300, 150, 100, 25));
	~algorithmButton0[4].states_([["Pan", Color.white, Color.blue.alpha_(0.8)]]);
	~algorithmButton0[4].font_(Font("Monaco", 10));
	~algorithmButton0[4].action_({
	RedGA.mutationFunc = {rrand(-1.0, 1.0);};
	pan0GenomeA = RedGAGenome.new(~panDataSelector0);
	pan0GenomeB = RedGAGenome.new(~panDataSelector1);
	RedGA.crossOverRate = pan0CrossoverRate0;
	pan0Crossover0 = RedGA.breedMultiPoint(pan0GenomeA, pan0GenomeB);
	pan0Crossover0.do{|x| x.chromosome};
	RedGA.mutationRate = pan0Mutation0;
	pan0Breed0 = RedGA.mutate(pan0Crossover0[0]).chromosome;
	~pan2Synth.set(\grain2PanArray0, pan0Breed0);
	~panArrayOut.addFirst(pan0Breed0);
	~panArrayOut.asArray.writeArchive(PathName.tmp ++ "PANARRAY");
	~revChooserPop0[4].items = Array.fill(~panArrayOut.size, {arg i; i.asString});
	~panKnob2[0].value_(\pan.asSpec.unmap(pan0Breed0[0]));
	~panKnob2[1].value_(\pan.asSpec.unmap(pan0Breed0[1]));
	~panKnob2[2].value_(\pan.asSpec.unmap(pan0Breed0[2]));
	~panKnob2[3].value_(\pan.asSpec.unmap(pan0Breed0[3]));
	~panKnob2[4].value_(\pan.asSpec.unmap(pan0Breed0[4]));
	~panKnob2[5].value_(\pan.asSpec.unmap(pan0Breed0[5]));
	~panKnob2[6].value_(\pan.asSpec.unmap(pan0Breed0[6]));
	~panKnob2[7].value_(\pan.asSpec.unmap(pan0Breed0[7]));
	~panKnob2[8].value_(\pan.asSpec.unmap(pan0Breed0[8]));
	~panKnob2[9].value_(\pan.asSpec.unmap(pan0Breed0[9]));
	~panKnob2[10].value_(\pan.asSpec.unmap(pan0Breed0[10]));
	~panKnob2[11].value_(\pan.asSpec.unmap(pan0Breed0[11]));
	~panKnob2[12].value_(\pan.asSpec.unmap(pan0Breed0[12]));
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Pan Evolved ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~algorithmButton0[4].valueAction = 1 }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	});

// Crossover Slider for Playback Rate
	~crossoverSlider0[5] = EZSlider(~w5, Rect(300, 213, 233, 12.5), "crossover", 		~volumeSpec0, initVal:0.1,unitWidth:30, numberWidth:30, layout:\horz);
	~crossoverSlider0[5].font_(Font("Monaco", 10));
	~crossoverSlider0[5].setColors(Color.clear,Color.white.alpha_(0.7));
	~crossoverSlider0[5].action_({|ez|
								pitch0CrossoverRate0 = ez.value;
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " Pitch Crossover  = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~crossoverSlider0[5].valueAction = " ++ ~crossoverSlider0[5].value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
								});

// Mutation Slider for Playback Rate
	~mutationSlider0[5] = EZSlider(~w5, Rect(500, 213, 233, 12.5), "mutation", 	~volumeSpec0, initVal:0.1,unitWidth:30, numberWidth:30, layout:\horz);
	~mutationSlider0[5].font_(Font("Monaco", 10));
	~mutationSlider0[5].setColors(Color.clear,Color.white.alpha_(0.7));
	~mutationSlider0[5].action_({|ez|
								pitch0Mutation0 = ez.value;
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " Pitch Mutation  = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~mutationSlider0[5].valueAction = " ++ ~mutationSlider0[5].value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
								});

// Execution button for Playback Rate GA; Mutation = -4 -- 4
	~algorithmButton0[5] = Button(~w5, Rect(300, 188, 100, 25));
	~algorithmButton0[5].states_([["Pitch", Color.white, Color.blue.alpha_(0.9)]]);
	~algorithmButton0[5].font_(Font("Monaco", 10));
	~algorithmButton0[5].action_({
	RedGA.mutationFunc = {rrand(-4.00, 4.00);};
	pitch0GenomeA = RedGAGenome.new(~pitchDataSelector0);
	pitch0GenomeB = RedGAGenome.new(~pitchDataSelector1);
	RedGA.crossOverRate = pitch0CrossoverRate0;
	pitch0Crossover0 = RedGA.breedMultiPoint(pitch0GenomeA, pitch0GenomeB);
	pitch0Crossover0.do{|x| x.chromosome};
	RedGA.mutationRate = pitch0Mutation0;
	pitch0Breed0 = RedGA.mutate(pitch0Crossover0[0]).chromosome;
	~granularMacroSynth2.set(\pitchArray0, pitch0Breed0);
	~decimateSynth2.set(\pitchArray0, pitch0Breed0);
	~pitch2Slider0.value_((pitch0Breed0+4)/8);
	~pitchArrayOut.addFirst(pitch0Breed0);
	~pitchArrayOut.asArray.writeArchive(PathName.tmp ++ "PITCHARRAY");
	~revChooserPop0[5].items = Array.fill(~pitchArrayOut.size, {arg i; i.asString});
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Pitch Evolved ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~algorithmButton0[5].valueAction = 1 }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);

	});

// Execution button for All GA; Mutation = as above
	~algorithmButton0[6] = Button(~w5, Rect(300, 225.5, 100, 25));
	~algorithmButton0[6].states_([["All", Color.white, Color.blue.alpha_(1)]]);
	~algorithmButton0[6].font_(Font("Monaco", 10));
	~algorithmButton0[6].action_({
	RedGA.mutationFunc = {rrand(0, 2000);};
	mfccGenomeA = RedGAGenome.new(~mfccDataSelector0);
	mfccGenomeB = RedGAGenome.new(~mfccDataSelector1);
	RedGA.crossOverRate = crossover0;
	mfccCrossover = RedGA.breedMultiPoint(mfccGenomeA, mfccGenomeB);
	mfccCrossover.do{|x| x.chromosome};
	RedGA.mutationRate = mutation0;
	mfccBreed = RedGA.mutate(mfccCrossover[0]).chromosome;
	~trackerSynth2.set(\mfccFeedback, mfccBreed);
	~mfccArrayOut.addFirst(mfccBreed.max(0.005));
	~mfccArrayOut.asArray.writeArchive(PathName.tmp ++ "MFCCARRAY");

	RedGA.mutationFunc = {rrand(0.01, 2.00);};
	envelopeGenomeA = RedGAGenome.new(~envelopeDataSelector0);
	envelopeGenomeB = RedGAGenome.new(~envelopeDataSelector1);
	RedGA.crossOverRate = crossover1;
	envelopeCrossover = RedGA.breedMultiPoint(envelopeGenomeA, envelopeGenomeB);
	envelopeCrossover.do{|x| x.chromosome};
	RedGA.mutationRate = mutation1;
	envelopeBreed = RedGA.mutate(envelopeCrossover[0]).chromosome;
	~envelopeSynth.set(\envelopeFeedback0, envelopeBreed);
	~granularMacroSynth2.set(\envelopeFeedback0, envelopeBreed);

		~grainAttack2Slider.value_([envelopeBreed[0], envelopeBreed[3], envelopeBreed[6], envelopeBreed[9], envelopeBreed[12], envelopeBreed[15], envelopeBreed[18], envelopeBreed[21], envelopeBreed[24], envelopeBreed[27], envelopeBreed[30], envelopeBreed[33], envelopeBreed[36]]/2);

		~grainRelease2Slider.value_([envelopeBreed[1], envelopeBreed[4], envelopeBreed[7], envelopeBreed[10], envelopeBreed[13], envelopeBreed[16], envelopeBreed[19], envelopeBreed[22], envelopeBreed[25], envelopeBreed[28], envelopeBreed[31], envelopeBreed[34], envelopeBreed[37]]/2);

		~grainAmplitude2Slider.value_([envelopeBreed[2], envelopeBreed[5], envelopeBreed[8], envelopeBreed[11], envelopeBreed[14], envelopeBreed[17], envelopeBreed[20], envelopeBreed[23], envelopeBreed[26], envelopeBreed[29], envelopeBreed[32], envelopeBreed[35], envelopeBreed[38]]);



	~envelopeArrayOut.addFirst(envelopeBreed);
	~envelopeArrayOut.asArray.writeArchive(PathName.tmp ++ "ENVELOPEARRAY");

	RedGA.mutationFunc = {rrand(0.01, 4.00);};
	duration0GenomeA = RedGAGenome.new(~durationDataSelector0);
	duration0GenomeB = RedGAGenome.new(~durationDataSelector1);
	RedGA.crossOverRate = duration0CrossoverRate0;
	duration0Crossover0 = RedGA.breedMultiPoint(duration0GenomeA, duration0GenomeB);
	duration0Crossover0.do{|x| x.chromosome};
	RedGA.mutationRate = duration0Mutation0;
	duration0Breed0 = RedGA.mutate(duration0Crossover0[0]).chromosome;
	~granularMacroSynth2.set(\onsetDuration2Array0, duration0Breed0.min(2));
	~feedbackDurationSlider0.value_((duration0Breed0.min(2))/4);
	~durationArrayOut.addFirst(duration0Breed0.min(2));
	~durationArrayOut.asArray.writeArchive(PathName.tmp ++ "DURATIONARRAY");
	RedGA.mutationFunc = {rrand(0.00, 1.00);};
	onset0GenomeA = RedGAGenome.new(~onsetDataSelector0);
	onset0GenomeB = RedGAGenome.new(~onsetDataSelector1);
	RedGA.crossOverRate = onset0CrossoverRate0;
	onset0Crossover0 = RedGA.breedMultiPoint(onset0GenomeA, onset0GenomeB);
	onset0Crossover0.do{|x| x.chromosome};
	RedGA.mutationRate = onset0Mutation0;
	onset0Breed0 = RedGA.mutate(onset0Crossover0[0]).chromosome;
	~analysisSynth.set(\onsetFeedback0, onset0Breed0);
		~onsetThresholdSlider2.value_(~thresholdSpec0.map(onset0Breed0));
	~onsetArrayOut.addFirst(onset0Breed0);
	~onsetArrayOut.asArray.writeArchive(PathName.tmp ++ "ONSETARRAY");

	RedGA.mutationFunc = {rrand(-1.0, 1.0);};
	pan0GenomeA = RedGAGenome.new(~panDataSelector0);
	pan0GenomeB = RedGAGenome.new(~panDataSelector1);
	RedGA.crossOverRate = pan0CrossoverRate0;
	pan0Crossover0 = RedGA.breedMultiPoint(pan0GenomeA, pan0GenomeB);
	pan0Crossover0.do{|x| x.chromosome};
	RedGA.mutationRate = pan0Mutation0;
	pan0Breed0 = RedGA.mutate(pan0Crossover0[0]).chromosome;
	~pan2Synth.set(\grain2PanArray0, pan0Breed0);
		~panKnob2[0].value_(\pan.asSpec.unmap(pan0Breed0[0]));
		~panKnob2[1].value_(\pan.asSpec.unmap(pan0Breed0[1]));
		~panKnob2[2].value_(\pan.asSpec.unmap(pan0Breed0[2]));
		~panKnob2[3].value_(\pan.asSpec.unmap(pan0Breed0[3]));
		~panKnob2[4].value_(\pan.asSpec.unmap(pan0Breed0[4]));
		~panKnob2[5].value_(\pan.asSpec.unmap(pan0Breed0[5]));
		~panKnob2[6].value_(\pan.asSpec.unmap(pan0Breed0[6]));
		~panKnob2[7].value_(\pan.asSpec.unmap(pan0Breed0[7]));
		~panKnob2[8].value_(\pan.asSpec.unmap(pan0Breed0[8]));
		~panKnob2[9].value_(\pan.asSpec.unmap(pan0Breed0[9]));
		~panKnob2[10].value_(\pan.asSpec.unmap(pan0Breed0[10]));
		~panKnob2[11].value_(\pan.asSpec.unmap(pan0Breed0[11]));
		~panKnob2[12].value_(\pan.asSpec.unmap(pan0Breed0[12]));
	~panArrayOut.addFirst(pan0Breed0);
	~panArrayOut.asArray.writeArchive(PathName.tmp ++ "PANARRAY");

	RedGA.mutationFunc = {rrand(-4.00, 4.00);};
	pitch0GenomeA = RedGAGenome.new(~pitchDataSelector0);
	pitch0GenomeB = RedGAGenome.new(~pitchDataSelector1);
	RedGA.crossOverRate = pitch0CrossoverRate0;
	pitch0Crossover0 = RedGA.breedMultiPoint(pitch0GenomeA, pitch0GenomeB);
	pitch0Crossover0.do{|x| x.chromosome};
	RedGA.mutationRate = pitch0Mutation0;
	pitch0Breed0 = RedGA.mutate(pitch0Crossover0[0]).chromosome;
	~granularMacroSynth2.set(\pitchArray0, pitch0Breed0);
	~decimateSynth2.set(\pitchArray0, pitch0Breed0);
	~pitch2Slider0.value_((pitch0Breed0+4)/8);
	~pitchArrayOut.addFirst(pitch0Breed0);
	~pitchArrayOut.asArray.writeArchive(PathName.tmp ++ "PITCHARRAY");

	~allArrayOut.addFirst(0);

	~revChooserPop0[0].items = Array.fill(~mfccArrayOut.size, {arg i; i.asString});
	~revChooserPop0[1].items = Array.fill(~envelopeArrayOut.size, {arg i; i.asString});
	~revChooserPop0[2].items = Array.fill(~durationArrayOut.size, {arg i; i.asString});
	~revChooserPop0[3].items = Array.fill(~onsetArrayOut.size, {arg i; i.asString});
	~revChooserPop0[4].items = Array.fill(~panArrayOut.size, {arg i; i.asString});
	~revChooserPop0[5].items = Array.fill(~pitchArrayOut.size, {arg i; i.asString});
	~revChooserPop0[6].items = Array.fill(~allArrayOut.size, {arg i; i.asString});

	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " All Evolved ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~algorithmButton0[6].valueAction = 1 }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	});

// create array of save buttons for GAs
	~save0Button0 = Array.new(7);
	save0ButtonArray0 = Array.fill(7, {arg i;
	~save0Button0.add();
	});

// Save current MFCC population to file
	~save0Button0[0] = Button(~w5, Rect(400, 0, 100, 25));
	~save0Button0[0].states_([["Save", Color.white, Color.blue.alpha_(0.4)]]);
	~save0Button0[0].font_(Font("Monaco", 10));
	~save0Button0[0].mouseDownAction_({
	CocoaDialog.savePanel({ arg paths;
				mfccBreed.max(0.005).asArray.writeArchive(paths.asString++".txt");
			~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Spectrum Saved to" ++ paths.asString ++ ".txt ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);

		},{
			"cancelled".postln;
		});
	});

// Save current Envelope population to file
	~save0Button0[1] = Button(~w5, Rect(400, 37.5, 100, 25));
	~save0Button0[1].states_([["Save", Color.white, Color.blue.alpha_(0.5)]]);
	~save0Button0[1].font_(Font("Monaco", 10));
	~save0Button0[1].mouseDownAction_({
	CocoaDialog.savePanel({ arg paths;
				envelopeBreed.asArray.writeArchive(paths.asString++".txt");
				~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Envelope Saved to" ++ paths.asString ++ ".txt ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
		},{
			"cancelled".postln;
		});
	});

// Save current Duration population to file
	~save0Button0[2] = Button(~w5, Rect(400, 75, 100, 25));
	~save0Button0[2].states_([["Save", Color.white, Color.blue.alpha_(0.6)]]);
	~save0Button0[2].font_(Font("Monaco", 10));
	~save0Button0[2].mouseDownAction_({
	CocoaDialog.savePanel({ arg paths;
				(duration0Breed0.min(2)).asArray.writeArchive(paths.asString++".txt");
				~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Duration Saved to" ++ paths.asString ++ ".txt ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);

		},{
			"cancelled".postln;
		});
	});

// Save current Threshold population to file
	~save0Button0[3] = Button(~w5, Rect(400, 112.5, 100, 25));
	~save0Button0[3].states_([["Save", Color.white, Color.blue.alpha_(0.7)]]);
	~save0Button0[3].font_(Font("Monaco", 10));
	~save0Button0[3].mouseDownAction_({
	CocoaDialog.savePanel({ arg paths;
				onset0Breed0.asArray.writeArchive(paths.asString++".txt");
				~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Threshold Saved to" ++ paths.asString ++ ".txt ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);

		},{
			"cancelled".postln;
		});
	});

// Save current Pan population to file
	~save0Button0[4] = Button(~w5, Rect(400, 150, 100, 25));
	~save0Button0[4].states_([["Save", Color.white, Color.blue.alpha_(0.8)]]);
	~save0Button0[4].font_(Font("Monaco", 10));
	~save0Button0[4].mouseDownAction_({
	CocoaDialog.savePanel({ arg paths;
				pan0Breed0.asArray.writeArchive(paths.asString++".txt");
					~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Pan Saved to" ++ paths.asString ++ ".txt ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);

		},{
			"cancelled".postln;
		});
	});

// Save current Playback Rate population to file
	~save0Button0[5] = Button(~w5, Rect(400, 187.5, 100, 25));
	~save0Button0[5].states_([["Save", Color.white, Color.blue.alpha_(0.9)]]);
	~save0Button0[5].font_(Font("Monaco", 10));
	~save0Button0[5].mouseDownAction_({
	CocoaDialog.savePanel({ arg paths;
				pitch0Breed0.asArray.writeArchive(paths.asString++".txt");

				~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Pitch Saved to" ++ paths.asString ++ ".txt ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);

		},{
			"cancelled".postln;
		});
	});

// Save current All population to file
	~save0Button0[6] = Button(~w5, Rect(400, 225, 100, 25));
	~save0Button0[6].states_([["Save All", Color.white, Color.blue.alpha_(1)]]);
	~save0Button0[6].font_(Font("Monaco", 10));
	~save0Button0[6].mouseDownAction_({
	CocoaDialog.savePanel({ arg paths;
				[mfccBreed, envelopeBreed, duration0Breed0.min(2), onset0Breed0, pan0Breed0, pitch0Breed0].writeArchive(paths.asString++".txt");

				~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " All Saved to" ++ paths.asString ++ ".txt ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);

		},{
			"cancelled".postln;
		});
	});

// create array of load buttons from file for GAs
	~load0Button0 = Array.new(7);
	load0ButtonArray0 = Array.fill(7, {arg i;
	~load0Button0.add();
	});

// load MFCC population from file
	~load0Button0[0] = Button(~w5, Rect(500, 0, 100, 25));
	~load0Button0[0].states_([["Load", Color.white, Color.blue.alpha_(0.4)]]);
	~load0Button0[0].font_(Font("Monaco", 10));
	~load0Button0[0].mouseDownAction_({
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
				mfccBreed = Object.readArchive(path0.asString);
				~trackerSynth2.set(\mfccFeedback, mfccBreed.asArray);
				~mfccArrayOut.addFirst(mfccBreed.max(0.005));
				~mfccArrayOut.asArray.writeArchive(PathName.tmp ++ "MFCCARRAY");
	~revChooserPop0[0].items = Array.fill(~mfccArrayOut.size, {arg i; i.asString});
				~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Spectrum Loaded from" ++ path0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		},{
			"cancelled".postln;
		});
	});

// load Envelope population from file
	~load0Button0[1] = Button(~w5, Rect(500, 37.5, 100, 25));
	~load0Button0[1].states_([["Load", Color.white, Color.blue.alpha_(0.5)]]);
	~load0Button0[1].font_(Font("Monaco", 10));
	~load0Button0[1].mouseDownAction_({
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
				envelopeBreed = Object.readArchive(path0.asString);
				~envelopeSynth.set(\envelopeFeedback0, envelopeBreed.asArray);
				~granularMacroSynth2.set(\envelopeFeedback0, envelopeBreed.asArray);
				~envelopeArrayOut.addFirst(envelopeBreed);
		~grainAttack2Slider.value_([envelopeBreed[0], envelopeBreed[3], envelopeBreed[6], envelopeBreed[9], envelopeBreed[12], envelopeBreed[15], envelopeBreed[18], envelopeBreed[21], envelopeBreed[24], envelopeBreed[27], envelopeBreed[30], envelopeBreed[33], envelopeBreed[36]]/2);

		~grainRelease2Slider.value_([envelopeBreed[1], envelopeBreed[4], envelopeBreed[7], envelopeBreed[10], envelopeBreed[13], envelopeBreed[16], envelopeBreed[19], envelopeBreed[22], envelopeBreed[25], envelopeBreed[28], envelopeBreed[31], envelopeBreed[34], envelopeBreed[37]]/2);

		~grainAmplitude2Slider.value_([envelopeBreed[2], envelopeBreed[5], envelopeBreed[8], envelopeBreed[11], envelopeBreed[14], envelopeBreed[17], envelopeBreed[20], envelopeBreed[23], envelopeBreed[26], envelopeBreed[29], envelopeBreed[32], envelopeBreed[35], envelopeBreed[38]]);
				~envelopeArrayOut.asArray.writeArchive(PathName.tmp ++ "ENVELOPEARRAY");
	~revChooserPop0[1].items = Array.fill(~envelopeArrayOut.size, {arg i; i.asString});
					~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Envelope Loaded from" ++ path0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
			})
		},{
			"cancelled".postln;
		});
	});

// load Duration population from file
	~load0Button0[2] = Button(~w5, Rect(500, 75, 100, 25));
	~load0Button0[2].states_([["Load", Color.white, Color.blue.alpha_(0.6)]]);
	~load0Button0[2].font_(Font("Monaco", 10));
	~load0Button0[2].mouseDownAction_({
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
				duration0Breed0 = Object.readArchive(path0.asString);
				~granularMacroSynth2.set(\onsetDuration2Array0, (duration0Breed0.min(2)).asArray);
		~feedbackDurationSlider0.value_((duration0Breed0.min(2))/4);
				~durationArrayOut.addFirst(duration0Breed0.min(2));
				~durationArrayOut.asArray.writeArchive(PathName.tmp ++ "DURATIONARRAY");
	~revChooserPop0[2].items = Array.fill(~durationArrayOut.size, {arg i; i.asString});
				~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Duration Loaded from" ++ path0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
			})
		},{
			"cancelled".postln;
		});
	});

// load Threshold population from file
	~load0Button0[3] = Button(~w5, Rect(500, 112.5, 100, 25));
	~load0Button0[3].states_([["Load", Color.white, Color.blue.alpha_(0.7)]]);
	~load0Button0[3].font_(Font("Monaco", 10));
	~load0Button0[3].mouseDownAction_({
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
				onset0Breed0 = Object.readArchive(path0.asString);
				~analysisSynth.set(\onsetFeedback0, onset0Breed0.asArray);
		~onsetThresholdSlider2.value_(~thresholdSpec0.map(onset0Breed0));
				~onsetArrayOut.addFirst(onset0Breed0);
				~onsetArrayOut.asArray.writeArchive(PathName.tmp ++ "ONSETARRAY");
	~revChooserPop0[3].items = Array.fill(~onsetArrayOut.size, {arg i; i.asString});
				~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Threshold Loaded from" ++ path0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
			})
		},{
			"cancelled".postln;
		});
	});

// load Pan population from file
	~load0Button0[4] = Button(~w5, Rect(500, 150, 100, 25));
	~load0Button0[4].states_([["Load", Color.white, Color.blue.alpha_(0.8)]]);
	~load0Button0[4].font_(Font("Monaco", 10));
	~load0Button0[4].mouseDownAction_({
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
				pan0Breed0 = Object.readArchive(path0.asString);
				~pan2Synth.set(\grain2PanArray0, pan0Breed0.asArray);
		~panKnob2[0].value_(\pan.asSpec.unmap(pan0Breed0[0]));
		~panKnob2[1].value_(\pan.asSpec.unmap(pan0Breed0[1]));
		~panKnob2[2].value_(\pan.asSpec.unmap(pan0Breed0[2]));
		~panKnob2[3].value_(\pan.asSpec.unmap(pan0Breed0[3]));
		~panKnob2[4].value_(\pan.asSpec.unmap(pan0Breed0[4]));
		~panKnob2[5].value_(\pan.asSpec.unmap(pan0Breed0[5]));
		~panKnob2[6].value_(\pan.asSpec.unmap(pan0Breed0[6]));
		~panKnob2[7].value_(\pan.asSpec.unmap(pan0Breed0[7]));
		~panKnob2[8].value_(\pan.asSpec.unmap(pan0Breed0[8]));
		~panKnob2[9].value_(\pan.asSpec.unmap(pan0Breed0[9]));
		~panKnob2[10].value_(\pan.asSpec.unmap(pan0Breed0[10]));
		~panKnob2[11].value_(\pan.asSpec.unmap(pan0Breed0[11]));
		~panKnob2[12].value_(\pan.asSpec.unmap(pan0Breed0[12]));
				~panArrayOut.addFirst(pan0Breed0);
				~panArrayOut.asArray.writeArchive(PathName.tmp ++ "PANARRAY");
	~revChooserPop0[4].items = Array.fill(~panArrayOut.size, {arg i; i.asString});
				~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Pan Loaded from" ++ path0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
			})
		},{
			"cancelled".postln;
		});
	});

// load Playback Rate population from file
	~load0Button0[5] = Button(~w5, Rect(500, 187.5, 100, 25));
	~load0Button0[5].states_([["Load", Color.white, Color.blue.alpha_(0.9)]]);
	~load0Button0[5].font_(Font("Monaco", 10));
	~load0Button0[5].mouseDownAction_({
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
				pitch0Breed0 = Object.readArchive(path0.asString);
				~granularMacroSynth2.set(\pitchArray0, pitch0Breed0);
				~decimateSynth2.set(\pitchArray0, pitch0Breed0);
				~pitch2Slider0.value_((pitch0Breed0+4)/8);
				~pitchArrayOut.addFirst(pitch0Breed0);
				~pitchArrayOut.asArray.writeArchive(PathName.tmp ++ "PITCHARRAY");
	~revChooserPop0[5].items = Array.fill(~pitchArrayOut.size, {arg i; i.asString});
				~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Pitch Loaded from" ++ path0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
			})
		},{
			"cancelled".postln;
		});
	});

// load All population from file
	~load0Button0[6] = Button(~w5, Rect(500, 225, 100, 25));
	~load0Button0[6].states_([["Load All", Color.white, Color.blue.alpha_(1)]]);
	~load0Button0[6].font_(Font("Monaco", 10));
	~load0Button0[6].mouseDownAction_({
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
				loadData0 = Object.readArchive(path0.asString);
				mfccBreed = loadData0[0].asArray;
				envelopeBreed = loadData0[1].asArray;
				duration0Breed0 = loadData0[2].asArray;
				onset0Breed0 = loadData0[3].asArray;
				pan0Breed0 = loadData0[4].asArray;
				pitch0Breed0 = loadData0[5].asArray;
				~trackerSynth2.set(\mfccFeedback, mfccBreed);
				~envelopeSynth.set(\envelopeFeedback0, envelopeBreed);
				~granularMacroSynth2.set(\envelopeFeedback0, envelopeBreed);

		~grainAttack2Slider.value_(~sliderSpec0.map([envelopeBreed[0], envelopeBreed[3], envelopeBreed[6], envelopeBreed[9], envelopeBreed[12], envelopeBreed[15], envelopeBreed[18], envelopeBreed[21], envelopeBreed[24], envelopeBreed[27], envelopeBreed[30], envelopeBreed[33], envelopeBreed[36]]/10));

		~grainRelease2Slider.value_(~sliderSpec0.map([envelopeBreed[1], envelopeBreed[4], envelopeBreed[7], envelopeBreed[10], envelopeBreed[13], envelopeBreed[16], envelopeBreed[19], envelopeBreed[22], envelopeBreed[25], envelopeBreed[28], envelopeBreed[31], envelopeBreed[34], envelopeBreed[37]]/10));

		~grainAmplitude2Slider.value_(~sliderSpec0.map([envelopeBreed[2], envelopeBreed[5], envelopeBreed[8], envelopeBreed[11], envelopeBreed[14], envelopeBreed[17], envelopeBreed[20], envelopeBreed[23], envelopeBreed[26], envelopeBreed[29], envelopeBreed[32], envelopeBreed[35], envelopeBreed[38]]));

		~granularMacroSynth2.set(\onsetDuration2Array0, duration0Breed0.min(2));
		~feedbackDurationSlider0.value_((duration0Breed0.min(2))/4);
		~analysisSynth.set(\onsetFeedback0, onset0Breed0);
		~onsetThresholdSlider2.value_(~thresholdSpec0.map(onset0Breed0));
		~pan2Synth.set(\grain2PanArray0, pan0Breed0);
		~panKnob2[0].value_(\pan.asSpec.unmap(pan0Breed0[0]));
		~panKnob2[1].value_(\pan.asSpec.unmap(pan0Breed0[1]));
		~panKnob2[2].value_(\pan.asSpec.unmap(pan0Breed0[2]));
		~panKnob2[3].value_(\pan.asSpec.unmap(pan0Breed0[3]));
		~panKnob2[4].value_(\pan.asSpec.unmap(pan0Breed0[4]));
		~panKnob2[5].value_(\pan.asSpec.unmap(pan0Breed0[5]));
		~panKnob2[6].value_(\pan.asSpec.unmap(pan0Breed0[6]));
		~panKnob2[7].value_(\pan.asSpec.unmap(pan0Breed0[7]));
		~panKnob2[8].value_(\pan.asSpec.unmap(pan0Breed0[8]));
		~panKnob2[9].value_(\pan.asSpec.unmap(pan0Breed0[9]));
		~panKnob2[10].value_(\pan.asSpec.unmap(pan0Breed0[10]));
		~panKnob2[11].value_(\pan.asSpec.unmap(pan0Breed0[11]));
		~panKnob2[12].value_(\pan.asSpec.unmap(pan0Breed0[12]));
		~granularMacroSynth2.set(\pitchArray0, pitch0Breed0);
		~decimateSynth2.set(\pitchArray0, pitch0Breed0);
		~pitch2Slider0.value_((pitch0Breed0+4)/8);
		~mfccArrayOut.addFirst(mfccBreed.max(0.005));
		~mfccArrayOut.asArray.writeArchive(PathName.tmp ++ "MFCCARRAY");
		~envelopeArrayOut.addFirst(envelopeBreed);
		~envelopeArrayOut.asArray.writeArchive(PathName.tmp ++ "ENVELOPEARRAY");
		~durationArrayOut.addFirst(duration0Breed0.min(2));
		~durationArrayOut.asArray.writeArchive(PathName.tmp ++ "DURATIONARRAY");
		~onsetArrayOut.addFirst(onset0Breed0);
		~onsetArrayOut.asArray.writeArchive(PathName.tmp ++ "ONSETARRAY");
		~panArrayOut.addFirst(pan0Breed0);
		~panArrayOut.asArray.writeArchive(PathName.tmp ++ "PANARRAY");
		~pitchArrayOut.addFirst(pitch0Breed0);
		~pitchArrayOut.asArray.writeArchive(PathName.tmp ++ "PITCHARRAY");
		~allArrayOut.addFirst(0);
		~revChooserPop0[0].items = Array.fill(~mfccArrayOut.size, {arg i; i.asString});
		~revChooserPop0[1].items = Array.fill(~envelopeArrayOut.size, {arg i; i.asString});
		~revChooserPop0[2].items = Array.fill(~durationArrayOut.size, {arg i; i.asString});
		~revChooserPop0[3].items = Array.fill(~onsetArrayOut.size, {arg i; i.asString});
		~revChooserPop0[4].items = Array.fill(~panArrayOut.size, {arg i; i.asString});
		~revChooserPop0[5].items = Array.fill(~pitchArrayOut.size, {arg i; i.asString});
		~revChooserPop0[6].items = Array.fill(~allArrayOut.size, {arg i; i.asString});
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " All Loaded from" ++ path0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.selectLine(~textEditor.string.size);
			})
		},{
			"cancelled".postln;
		});
	});

// Tempo text for control one
	~tempo0Textbox0 = StaticText(~w7, Rect(321, 117, 80, 25));
	~tempo0Textbox0.background_(Color.yellow.alpha_(0));
	~tempo0Textbox0.font_(Font.new("Monaco", 17));
	~tempo0Textbox0.stringColor = Color.white.alpha_(0.5);

// Tempo text for control two
	~tempo1Textbox0 = StaticText(~w7, Rect(1920/3 + 321, 117, 100, 25));
	~tempo1Textbox0.background_(Color.red.alpha_(0));
	~tempo1Textbox0.font_(Font.new("Monaco", 17));
	~tempo1Textbox0.stringColor = Color.white.alpha_(0.5);

// Tempo text for control three/slave
	~tempo2Textbox0 = StaticText(~w7, Rect(1920/3 * 2 + 321, 117, 80, 25));
	~tempo2Textbox0.background_(Color.blue.alpha_(0));
	~tempo2Textbox0.font_(Font.new("Monaco", 17));
	~tempo2Textbox0.stringColor = Color.white.alpha_(0.5);

// Slider for control one output volume
	~osc0LevelSlider0 = EZSlider(~w1, Rect(1920/3-25, 0, 25, 300), "", ~volumeSpec0, initVal:0, unitWidth:0, numberWidth:30, layout:\vert);
	~osc0LevelSlider0.font_(Font("Monaco", 10));
	~osc0LevelSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.yellow, Color.clear);

// Slider for control two output volume
	~osc1LevelSlider0 = EZSlider(~w1, Rect((1920/3-12.5)*2, 0, 25, 300), "", ~volumeSpec0, initVal:0, unitWidth:0, numberWidth:30, layout:\vert);
	~osc1LevelSlider0.font_(Font("Monaco", 10));
	~osc1LevelSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.red, Color.clear);

// Slider for control three/slave output volume
	~osc2LevelSlider0 = EZSlider(~w1, Rect((1920/3-9)*3, 0, 25, 300), "", ~volumeSpec0, initVal:0, unitWidth:0, numberWidth:30, layout:\vert);
	~osc2LevelSlider0.font_(Font("Monaco", 10));
	~osc2LevelSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.blue, Color.clear);

// Slider for control one sample ugen pitch
	~osc0PitchSlider0 = EZSlider(~w7, Rect(400, 26, 30, 120), "", ~pitch0spec0, initVal:1, unitWidth:0, numberWidth:30, layout:\vert);
	~osc0PitchSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.yellow.alpha_(0.5), Color.clear);
	~osc0PitchSlider0.font_(Font("Monaco", 10));

// Slider for control one sample ugen grain length
	~grainLengthSlider0 = EZSlider(~w7, Rect(440, 26, 30, 120), "", ~grainLengthSpec0, initVal:0.1, unitWidth:0, numberWidth:30, layout:\vert);
	~grainLengthSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, Color.white, Color.yellow.alpha_(0.5), Color.clear);
	~grainLengthSlider0.font_(Font("Monaco", 10));

// Slider for control one sample ugen times stretch
	~osc0StretchSlider0 = EZSlider(~w7, Rect(480, 26, 30, 120), "", ~rate0Spec0, initVal:1, unitWidth:0, numberWidth:40, layout:\vert);
	~osc0StretchSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.yellow.alpha_(0.5), Color.clear);
	~osc0StretchSlider0.font_(Font("Monaco", 10));

// Slider for control one decimator
	~samplerateSlider0 = EZSlider(~w7, Rect(520, 26, 30, 120), "", ~sampleRateSpec0, initVal:0, unitWidth:0, numberWidth:30, layout:\vert);
	~samplerateSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.yellow.alpha_(0.5), Color.clear);
	~samplerateSlider0.font_(Font("Monaco", 10));

// Slider for control one averaging update speed
	~trackingUpdateSlider1 = EZSlider(~w7, Rect(560, 26, 30, 120), "", ~meanSpec1, unitWidth:0, numberWidth:0, layout:\vert, initVal:20);
	~trackingUpdateSlider1.font_(Font("Monaco", 10));
	~trackingUpdateSlider1.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.yellow.alpha_(0.5), Color.clear);

// Slider for control one spectral following base frequency adjustment
	~filterAdjuster0 = EZSlider(~w7, Rect(600, 26, 30, 120), "", ~adjusterSpec0, unitWidth:0, numberWidth:0, layout:\vert, initVal:-2000);
	~filterAdjuster0.font_(Font("Monaco", 10));
	~filterAdjuster0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.yellow.alpha_(0.5), Color.clear);

// Slider for control two sample ugen pitch
	~osc1PitchSlider0 = EZSlider(~w7, Rect(1920/3 + 400, 26, 30, 120), "", ~pitch0spec0, initVal:1, unitWidth:0, numberWidth:30, layout:\vert);
	~osc1PitchSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.red.alpha_(0.5), Color.clear);
	~osc1PitchSlider0.font_(Font("Monaco", 10));

// Slider for control two sample ugen grain length
	~grainLengthSlider1 = EZSlider(~w7, Rect(1920/3 + 440, 26, 30, 120), "", ~grainLengthSpec0, initVal:0.1, unitWidth:0, numberWidth:30, layout:\vert);
	~grainLengthSlider1.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, Color.white, Color.red.alpha_(0.5), Color.clear);
	~grainLengthSlider1.font_(Font("Monaco", 10));

// Slider for control one sample ugen times stretch
	~osc1StretchSlider0 = EZSlider(~w7, Rect(1920/3 + 480, 26, 30, 120), "", ~rate0Spec0, initVal:1, unitWidth:0, numberWidth:40, layout:\vert);
	~osc1StretchSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.red.alpha_(0.5), Color.clear);
	~osc1StretchSlider0.font_(Font("Monaco", 10));

// Slider for control two decimator
	~samplerateSlider1 = EZSlider(~w7, Rect(1920/3 + 520, 26, 30, 120), "", ~sampleRateSpec0, initVal:0, unitWidth:0, numberWidth:30, layout:\vert);
	~samplerateSlider1.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.red.alpha_(0.5), Color.clear);
	~samplerateSlider1.font_(Font("Monaco", 10));

// Slider for control two averaging update speed
	~trackingUpdateSlider2 = EZSlider(~w7, Rect(1920/3 + 560, 26, 30, 120), "", ~meanSpec1, unitWidth:0, numberWidth:0, layout:\vert, initVal:20);
	~trackingUpdateSlider2.font_(Font("Monaco", 10));
	~trackingUpdateSlider2.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.red.alpha_(0.5), Color.clear);

// Slider for control two spectral following base frequency adjustment
	~filterAdjuster1 = EZSlider(~w7, Rect(1920/3 + 600, 26, 30, 120), "", ~adjusterSpec0, unitWidth:0, numberWidth:0, layout:\vert, initVal:-2000);
	~filterAdjuster1.font_(Font("Monaco", 10));
	~filterAdjuster1.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.red.alpha_(0.5), Color.clear);

// Slider for control three pitch
	~osc2PitchSlider0 = EZSlider(~w7, Rect(1920/3 * 2 + 400, 26, 30, 120), "", ~pitch0spec0, initVal:1, unitWidth:0, numberWidth:30, layout:\vert);
	~osc2PitchSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.blue.alpha_(0.5), Color.clear);
	~osc2PitchSlider0.font_(Font("Monaco", 10));

// Slider for control three sample ugen grain length
	~grainLengthSlider2 = EZSlider(~w7, Rect(1920/3 * 2 + 440, 26, 30, 120), "", ~grainLengthSpec0, initVal:0.1, unitWidth:0, numberWidth:30, layout:\vert);
	~grainLengthSlider2.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, Color.white, Color.blue.alpha_(0.5), Color.clear);
	~grainLengthSlider2.font_(Font("Monaco", 10));

// Slider for control three time stretch
	~osc2StretchSlider0 = EZSlider(~w7, Rect(1920/3 * 2 + 480, 26, 30, 120), "", ~rate0Spec0, initVal:1, unitWidth:0, numberWidth:40, layout:\vert);
	~osc2StretchSlider0.font_(Font("Monaco", 10));
	~osc2StretchSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.blue.alpha_(0.5), Color.clear);

// Slider for control three decimator
	~samplerateSlider2 = EZSlider(~w7, Rect(1920/3 * 2 + 520, 26, 30, 120), "", ~sampleRateSpec0, initVal:0, unitWidth:0, numberWidth:30, layout:\vert);
	~samplerateSlider2.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.blue.alpha_(0.5), Color.clear);
	~samplerateSlider2.font_(Font("Monaco", 10));

// Slider for control three averaging update speed
	~trackingUpdateSlider3 = EZSlider(~w7, Rect(1920/3 * 2 + 560, 26, 30, 120), "", ~meanSpec1, unitWidth:0, numberWidth:0, layout:\vert, initVal:20);
	~trackingUpdateSlider3.font_(Font("Monaco", 10));
	~trackingUpdateSlider3.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.blue.alpha_(0.5), Color.clear);

// Slider for control three spectral following base frequency adjustment
	~filterAdjuster2 = EZSlider(~w7, Rect(1920/3 * 2 + 600, 26, 30, 120), "", ~adjusterSpec1, unitWidth:0, numberWidth:0, layout:\vert, initVal:0);
	~filterAdjuster2.font_(Font("Monaco", 10));
	~filterAdjuster2.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.blue.alpha_(0.5), Color.clear);

// Slider for output level of dry auditory mix
	~dryLevelSlider0 = EZSlider(~w6, Rect(25, 25, 25, 250), "", ~volumeSpec0, initVal:1, unitWidth:0, numberWidth:30, layout:\vert);
	~dryLevelSlider0.font_(Font("Monaco", 10));
	~dryLevelSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.black, Color.white, 	Color.white, Color.white, Color.clear);

// overall level of all output mixes
	~mainOutSlider0 = EZSlider(~w6, Rect(425, 25, 25, 250), "", ~volumeSpec0, initVal:1, unitWidth:0, numberWidth:30, layout:\vert);
	~mainOutSlider0.font_(Font("Monaco", 10));
	~mainOutSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.black, Color.white, 	Color.white, Color.red, Color.clear);

// Slider for output level of fx auditory mix
	~fxLevelSlider0 = EZSlider(~w6, Rect(50, 25, 25, 250), "", ~volumeSpec0, initVal:0, unitWidth:0, numberWidth:30, layout:\vert);
	~fxLevelSlider0.font_(Font("Monaco", 10));
	~fxLevelSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.black, Color.white, 	Color.white, Color.black, Color.clear);

// Slider for output level of granular synthesizers mix controlled by onsets of control one
	~grainLevel0Slider = EZSlider(~w6, Rect(75, 25, 25, 250), "", ~volumeSpec0, initVal:0, unitWidth:0, numberWidth:30, layout:\vert);
	~grainLevel0Slider.font_(Font("Monaco", 10));
	~grainLevel0Slider.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.black, Color.white, 	Color.white, Color.yellow, Color.clear);

// Slider for output level of freeze mix controlled by onsets of control one
	~filterSlider0 = EZSlider(~w6, Rect(100, 25, 25, 250), "", ~volumeSpec0, initVal:0, unitWidth:0, numberWidth:30, layout:\vert);
	~filterSlider0.font_(Font("Monaco", 10));
	~filterSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.black, Color.white, 	Color.white, Color.yellow, Color.clear);

// Slider for output level of granular synthesizers mix controlled by onsets of control two
	~grainLevel1Slider = EZSlider(~w6, Rect(125, 25, 25, 250), "", ~volumeSpec0, initVal:0, unitWidth:0, numberWidth:30, layout:\vert);
	~grainLevel1Slider.font_(Font("Monaco", 10));
	~grainLevel1Slider.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.black, Color.white, 	Color.white, Color.red, Color.clear);

// Slider for output level of freeze mix controlled by onsets of control two
	~filterSlider1 = EZSlider(~w6, Rect(150, 25, 25, 250), "", ~volumeSpec0, initVal:0, unitWidth:0, numberWidth:30, layout:\vert);
	~filterSlider1.font_(Font("Monaco", 10));
	~filterSlider1.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.black, Color.white, 	Color.white, Color.red, Color.clear);

// Slider for output level of granular synthesizers mix controlled by onsets of control three/slave
	~grainLevel2Slider = EZSlider(~w6, Rect(175, 25, 25, 250), "", ~volumeSpec0, initVal:0, unitWidth:0, numberWidth:30, layout:\vert);
	~grainLevel2Slider.font_(Font("Monaco", 10));
	~grainLevel2Slider.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.black, Color.white, 	Color.white, Color.blue, Color.clear);

// Slider for output level of freeze mix controlled by onsets of control three/slave
	~filterSlider2 = EZSlider(~w6, Rect(200, 25, 25, 250), "", ~volumeSpec0, initVal:0, unitWidth:0, numberWidth:30, layout:\vert);
	~filterSlider2.font_(Font("Monaco", 10));
	~filterSlider2.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.black, Color.white, 	Color.white, Color.blue, Color.clear);

// level adjuster of SoundIn.ar input
	~micLevelSlider0 = EZSlider(~w6, Rect(450, 25, 25, 250), "", ~micLevelSpec0, initVal:1, unitWidth:0, numberWidth:25, layout:\vert);
	~micLevelSlider0.font_(Font("Monaco", 10));
	~micLevelSlider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.black, Color.white, 	Color.white, Color.green, Color.clear);

// tempo following toggle for control source three
	~beatSwitch0 = Button(~w5, Rect(100, 125, 100, 25));
	~beatSwitch0.font_(Font("Monaco", 10));
	~beatSwitch0.states_([
					["Beat Track Off",Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["Beat Track On",Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~beatSwitch0.action_({arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\beatChooser1, 0);
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Beat Track Off "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~beatSwitch0.valueAction = " ++ ~beatSwitch0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);	},
	{~bufferSynth.set(\beatChooser1, 1); ~osc2StretchSlider0.valueAction_(1);
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Beat Track On "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~beatSwitch0.valueAction = " ++ ~beatSwitch0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);}
	)
	});

// tempo following control source toggle between control one and control two
	~masterSwitch0 = Button(~w5, Rect(100, 75, 100, 25));
	~masterSwitch0.font_(Font("Monaco", 10));
	~masterSwitch0.states_([
					["Master",Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["Master",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
							]);

	~masterSwitch0.action_({arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\masterChooser, 0);
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Beat Track Master is Yellow "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~masterSwitch0.valueAction = " ++ ~masterSwitch0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);	},
	{~bufferSynth.set(\masterChooser, 1);
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Beat Track Master is Red "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~masterSwitch0.valueAction = " ++ ~masterSwitch0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);		}
	)
	});

// tempo following toggle for control source two
	~beatTrackChooser0 = Button(~w5, Rect(100, 100, 100, 25));
	~beatTrackChooser0.font_(Font("Monaco", 10));
	~beatTrackChooser0.states_([
					["Beat Track Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Beat Track On",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~beatTrackChooser0.action_({arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\beatChooser, 0); ~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Beat Track Off "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~beatTrackChooser0.valueAction = " ++ ~beatTrackChooser0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);			},
	{~bufferSynth.set(\beatChooser, 1); ~osc1StretchSlider0.value_(1); ~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Beat Track On "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~beatTrackChooser0.valueAction = " ++ ~beatTrackChooser0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);			}
	)
	});

// spectal following toggle for granular synthesizers triggered by control one
	~onsetChooser0 = Button(~w5, Rect(200, 75, 100, 25));
	~onsetChooser0.font_(Font("Monaco", 10));
	~onsetChooser0.states_([
					["Static",Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["Dynamic",Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);

// spectal following toggle for granular synthesizers triggered by control two
	~onsetChooser1 = Button(~w5, Rect(200, 100, 100, 25));
	~onsetChooser1.font_(Font("Monaco", 10));
	~onsetChooser1.states_([
					["Static",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Dynamic",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

// spectal following toggle for granular synthesizers triggered by control three/slave
	~onsetChooser2 = Button(~w5, Rect(200, 125, 100, 25));
	~onsetChooser2.font_(Font("Monaco", 10));
	~onsetChooser2.states_([
					["Static",Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["Dynamic",Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

// toggle filter for granular synthesizers triggered by control one
	~filterOn0 = Button(~w6, Rect(325, 50, 100, 50));
	~filterOn0.font_(Font("Monaco", 10));
	~filterOn0.states_([
					["Filter Off",Color.black,Color.yellow.alpha_(0.8)],
					["Filter On",Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);

// toggle filter for granular synthesizers triggered by control two
	~filterOn1 = Button(~w6, Rect(325, 100, 100, 50));
	~filterOn1.font_(Font("Monaco", 10));
	~filterOn1.states_([
					["Filter Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Filter On",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

// toggle filter for granular synthesizers triggered by control three/slave
	~filterOn2 = Button(~w6, Rect(325, 150, 100, 50));
	~filterOn2.font_(Font("Monaco", 10));
	~filterOn2.states_([
					["Filter Off",Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["Filter On",Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

// toggle pitch following process
	~pitchTrackButton0 = Button(~w5, Rect(100, 150, 100, 25));
	~pitchTrackButton0.font_(Font("Monaco", 10));
	~pitchTrackButton0.states_([
					["Pitch Track Off",Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["Pitch Track On",Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

// multiplied for envelope following process
	~envelopeAdjuster0 = EZSlider(~w5, Rect(300, 275, 400, 25), "Envelope Adjuster", ~envelopeMultiplierSpec0, labelWidth: 102, layout:\horz, initVal:1);
	~envelopeAdjuster0.font_(Font("Monaco", 10));
	~envelopeAdjuster0.setColors(Color.clear, Color.white.alpha_(0.8), Color.clear, Color.clear, Color.white.alpha_(0.8), Color.white.alpha_(0.8), 	Color.white.alpha_(0.8), Color.blue, Color.clear);

// create array of pan knobs for granular synthesizers triggered by control one
	~panKnob0 = Array.new(13);
	~panKnob0Array0 = Array.fill(13, {arg i;
	~panKnob0.add(Knob.new(~w7, Rect(i*(1920/3.25)/13, 0, (1920/3)/20, (1920/3)/20)));
	~panKnob0[i].value_(\pan.asSpec.unmap(0));
	~panKnob0[i].skin_(GUI.skins.default.knob.center_(Color.black.alpha_(0.2)););
	~panKnob0[i].skin_(GUI.skins.default.knob.level_(Color.yellow.alpha_(0.8)));
	~panKnob0[i].skin_(GUI.skins.default.knob.dial_(Color.yellow.alpha_(0.8)));
	~panKnob0[i].centered_(true);
	});

//control source one random movement


//difference Array and button
	~differenceArray0 = [0.7, 0.2, 0.1];

	~differenceButton0 = PopUpMenu(~w7, Rect(1920/3.25, 15, (1920/3)/20, 15));
	~differenceButton0.items = ["small change more likely", "med change more likely", "large change more likely"];
	~differenceButton0.value = 0;
	~differenceButton0.action = {arg menu;

	if(menu.value == 0,
	{
	~differenceArray0 = [0.7, 0.2, 0.1];
	}
	);

	if(menu.value == 1,
	{
	~differenceArray0 = [0.1, 0.7, 0.2];
	}
	);

	if(menu.value == 2,
	{
	~differenceArray0 = [0.1, 0.2, 0.7];
	}
	);

	};

//random control source one button

	~randButton0 = Button(~w7, Rect(1920/3.25, 0, (1920/3)/20, 15));
	~randButton0.font_(Font("Monaco", 9));
	~randButton0.states_([
					["Rand",Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["Rand",Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);

	~randButton0.action_({arg butt;
	if ( butt.value == 1,
	{

//create random arrays

	~randPanArray0 = [rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50)];

	~randPanDiff0 = pan0Data0 - ~randPanArray0;

	~randDurationArray0 = [rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00)];

	~randDurationDiff0 = duration0Data0 - ~randDurationArray0;

	~randPitchArray0 = [rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00)];

	~randPitchDiff0 = pitch0Data0 - ~randPitchArray0;

	~randAmpArray0 = [rrand(0,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00)];

	~randAmpDiff0 = envelope0Data0 - ~randAmpArray0;

	~randThresholdArray0 = [rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50)];

	~randThresholdDiff0 = onset0Data0 - ~randThresholdArray0;


//random routine
	~randRoutine0 = Routine.new({
    inf.do({ arg i;

//ensure valid values
	~checkRandPanDiff0 = Array.fill(13, {arg i;
	if(~randPanDiff0[i] <= -1,
	{
	~randPanDiff0[i] = rrand(-0.50, 0.50);
	}
	);
	if(~randPanDiff0[i] >= 1,
	{
	~randPanDiff0[i] = rrand(-0.50, 0.50);
	}
	);
	});

	~checkRandDurationDiff0 = Array.fill(13, {arg i;
	if(~randDurationDiff0[i] >= 4,
	{
	~randDurationDiff0[i] = rrand(0.05, 2.00);
	}

	);
	if(~randDurationDiff0[i] <= 0.05,
	{
	~randDurationDiff0[i] = rrand(0.05, 2.00);
	}
	);
	});

	~checkRandPitchDiff0 = Array.fill(13, {arg i;
	if(~randPitchDiff0[i] >= 4,
	{
	~randPitchDiff0[i] = rrand(-2.00, 2.00);
	}

	);
	if(~randPitchDiff0[i] <= -4,
	{
	~randPitchDiff0[i] = rrand(-2.00, 2.00);
	}
	);
	});

	~checkRandAmpDiff0 = Array.fill(13, {arg i;
	if(~randAmpDiff0[i] >= 1,
	{
	~randAmpDiff0[i] = rrand(0.50, 1.00);
	}

	);
	if(~randAmpDiff0[i] < 0,
	{
	~randAmpDiff0[i] = rrand(0.50, 1.00);
	}
	);
	});

	~checkRandThresholdDiff0 = Array.fill(13, {arg i;
	if(~randThresholdDiff0[i] >= 1,
	{
	~randThresholdDiff0[i] = rrand(0.00, 0.50);
	}

	);
	if(~randThresholdDiff0[i] < 0,
	{
	~randThresholdDiff0[i] = rrand(0.00, 0.50);
	}
	);
	});

//send values to synths and GUI

	{
	~panners0Array = Array.fill(13, {arg i;
	~panKnob0[i].valueAction = \pan.asSpec.unmap(~randPanDiff0[i]);
	};
	);

	~onsetDurationSlider0.value = ~randDurationDiff0/10;
	~grainAttack0Slider.value = ~randDurationDiff0/10;
	~grainRelease0Slider.value = ~randDurationDiff0/10;
	~onset0DurationArray0 = Array.fill(13, {arg i;
	~granularMacroSynth0.set("onset0Duration" ++ i.asString, ~randDurationDiff0[i]);
	~envelopeSynth.set("grain0Attack" ++ i.asString, (~randDurationDiff0[i])/2.1);
	~envelopeSynth.set("grain0Release" ++ i.asString, (~randDurationDiff0[i])/2.1);
	~granularMacroSynth2.set("grain0Attack" ++ i.asString, (~randDurationDiff0[i])/2.1);
	~granularMacroSynth2.set("grain0Release" ++ i.asString, (~randDurationDiff0[i])/2.1);

	});

	~pitch0Slider0.value = ~randPitchDiff0/4;
	~pitch0Slider0Array = Array.fill(13, {arg i;
	~granularMacroSynth0.set("grain0Pitch" ++ i.asString, ~randPitchDiff0[i])});

	~grainAmplitude0Slider.value = ~randAmpDiff0;
	~grainAmplitude0Array0 = Array.fill(13, {arg i;
	~envelopeSynth.set("grain0Amplitude" ++ i.asString, ~randAmpDiff0[i]);});

	~onsetThresholdSlider0.value = ~randThresholdDiff0;
	~onsetThresholdArray0 = Array.fill(13, {arg i;
	~analysisSynth.set("osc0OnsetThreshold" ++ i.asString, ~randThresholdDiff0[i])});

	}.defer;


//add changes to current data
	~smallChange0 = [rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1)];
	~medChange0 = [rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5)];
	~largeChange0 = [rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0)];

//wchoose amount of change
	~randPanDiff0 = [~randPanDiff0 + ~smallChange0, ~randPanDiff0 + ~medChange0, ~randPanDiff0 + ~largeChange0].wchoose(~differenceArray0);
	~randDurationDiff0 = [~randDurationDiff0 + ~smallChange0, ~randDurationDiff0 + ~medChange0, ~randDurationDiff0 + ~largeChange0].wchoose(~differenceArray0);
	~randPitchDiff0 = [~randPitchDiff0 + ~smallChange0, ~randPitchDiff0 + ~medChange0, ~randPitchDiff0 + ~largeChange0].wchoose(~differenceArray0);
	~randAmpDiff0 = [~randAmpDiff0 + ~smallChange0, ~randAmpDiff0 + ~medChange0, ~randAmpDiff0 + ~largeChange0].wchoose(~differenceArray0);
	~randThresholdDiff0 = [~randThresholdDiff0 + ~smallChange0, ~randThresholdDiff0 + ~medChange0, ~randThresholdDiff0 + ~largeChange0].wchoose(~differenceArray0);


//set duration between each change relative to control source one tempo
	~randDurationChooser0 = [0.1, 0.2, 0.33, 0.5, 0.66, 1, 2].choose;

	(~tempo0Message0*~randDurationChooser0).wait;

    });
	});

	~randRoutine0.reset;
	~randRoutine0.play;

	}

	);

	if (butt.value == 0,

	{

	~randRoutine0.stop;

	});

	});

	~panKnob0[0].action = {|v,x,y,m|
								~pan0Synth.set(
								"grain0panner0", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob0[0].valueAction  = " ++ ~panKnob0[0].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob0[1].action = {|v,x,y,m|
								~pan0Synth.set(
								"grain0panner1", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob0[1].valueAction  = " ++ ~panKnob0[1].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob0[2].action = {|v,x,y,m|
								~pan0Synth.set(
								"grain0panner2", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob0[2].valueAction  = " ++ ~panKnob0[2].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob0[3].action = {|v,x,y,m|
								~pan0Synth.set(
								"grain0panner3", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob0[3].valueAction  = " ++ ~panKnob0[3].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob0[4].action = {|v,x,y,m|
								~pan0Synth.set(
								"grain0panner4", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob0[4].valueAction  = " ++ ~panKnob0[4].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob0[5].action = {|v,x,y,m|
								~pan0Synth.set(
								"grain0panner5", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob0[5].valueAction  = " ++ ~panKnob0[5].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};
	~panKnob0[6].action = {|v,x,y,m|
								~pan0Synth.set(
								"grain0panner6", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob0[6].valueAction  = " ++ ~panKnob0[6].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob0[7].action = {|v,x,y,m|
								~pan0Synth.set(
								"grain0panner7", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob0[7].valueAction  = " ++ ~panKnob0[7].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob0[8].action = {|v,x,y,m|
								~pan0Synth.set(
								"grain0panner8", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob0[8].valueAction  = " ++ ~panKnob0[8].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob0[9].action = {|v,x,y,m|
								~pan0Synth.set(
								"grain0panner9", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob0[9].valueAction  = " ++ ~panKnob0[9].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob0[10].action = {|v,x,y,m|
								~pan0Synth.set(
								"grain0panner10", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob0[10].valueAction  = " ++ ~panKnob0[10].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob0[11].action = {|v,x,y,m|
								~pan0Synth.set(
								"grain0panner11", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob0[11].valueAction  = " ++ ~panKnob0[11].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob0[12].action = {|v,x,y,m|
								~pan0Synth.set(
								"grain0panner12", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob0[12].valueAction  = " ++ ~panKnob0[12].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

// create array of pan knobs for granular synthesizers triggered by control two
	~panKnob1 = Array.new(13);
	~panKnob1Array0 = Array.fill(13, {arg i;
	~panKnob1.add(Knob.new(~w7, Rect(i*((1920/3.25)/13)+640, 0, (1920/3)/20, (1920/3)/20)));
	~panKnob1[i].value_(\pan.asSpec.unmap(0));
	~panKnob1[i].skin_(GUI.skins.default.knob.center_(Color.black.alpha_(0.2)););
	~panKnob1[i].skin_(GUI.skins.default.knob.level_(Color.red.alpha_(0.8)));
	~panKnob1[i].skin_(GUI.skins.default.knob.dial_(Color.red.alpha_(0.8)));
	~panKnob1[i].centered_(true);
	});

//control source two random movement


//difference Array and button
	~differenceArray1 = [0.7, 0.2, 0.1];

	~differenceButton1 = PopUpMenu(~w7, Rect((1920/3.25)+640, 15, (1920/3)/20, 15));
	~differenceButton1.items = ["small change more likely", "med change more likely", "large change more likely"];
	~differenceButton1.value = 0;
	~differenceButton1.action = {arg menu;

	if(menu.value == 0,
	{
	~differenceArray1 = [0.7, 0.2, 0.1];
	}
	);

	if(menu.value == 1,
	{
	~differenceArray1 = [0.1, 0.7, 0.2];
	}
	);

	if(menu.value == 2,
	{
	~differenceArray1 = [0.1, 0.2, 0.7];
	}
	);

	};

//random control source two button

	~randButton1 = Button(~w7, Rect((1920/3.25)+640, 0, (1920/3)/20, 15));
	~randButton1.font_(Font("Monaco", 9));
	~randButton1.states_([
					["Rand",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Rand",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~randButton1.action_({arg butt;
	if ( butt.value == 1,
	{

//create random arrays

	~randPanArray1 = [rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50), rrand(-0.50,0.50)];

	~randPanDiff1 = pan1Data0 - ~randPanArray1;

	~randDurationArray1 = [rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00), rrand(0.05,2.00)];

	~randDurationDiff1 = duration1Data0 - ~randDurationArray1;

	~randPitchArray1 = [rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00), rrand(-2.00,2.00)];

	~randPitchDiff1 = pitch1Data0 - ~randPitchArray1;

	~randAmpArray1 = [rrand(0,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00), rrand(0.00,1.00)];

	~randAmpDiff1 = envelope1Data0 - ~randAmpArray1;

	~randThresholdArray1 = [rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50), rrand(0.00,0.50)];

	~randThresholdDiff1 = onset1Data0 - ~randThresholdArray1;


//random routine
	~randRoutine1 = Routine.new({
    inf.do({ arg i;

//ensure valid values
	~checkRandPanDiff1 = Array.fill(13, {arg i;
	if(~randPanDiff1[i] <= -1,
	{
	~randPanDiff1[i] = rrand(-0.50, 0.50);
	}
	);
	if(~randPanDiff1[i] >= 1,
	{
	~randPanDiff1[i] = rrand(-0.50, 0.50);
	}
	);
	});

	~checkRandDurationDiff1 = Array.fill(13, {arg i;
	if(~randDurationDiff1[i] >= 4,
	{
	~randDurationDiff1[i] = rrand(0.05, 2.00);
	}

	);
	if(~randDurationDiff1[i] <= 0.05,
	{
	~randDurationDiff1[i] = rrand(0.05, 2.00);
	}
	);
	});

	~checkRandPitchDiff1 = Array.fill(13, {arg i;
	if(~randPitchDiff1[i] >= 4,
	{
	~randPitchDiff1[i] = rrand(-2.00, 2.00);
	}

	);
	if(~randPitchDiff1[i] <= -4,
	{
	~randPitchDiff1[i] = rrand(-2.00, 2.00);
	}
	);
	});

	~checkRandAmpDiff1 = Array.fill(13, {arg i;
	if(~randAmpDiff1[i] >= 1,
	{
	~randAmpDiff1[i] = rrand(0.50, 1.00);
	}

	);
	if(~randAmpDiff1[i] < 0,
	{
	~randAmpDiff1[i] = rrand(0.50, 1.00);
	}
	);
	});

	~checkRandThresholdDiff1 = Array.fill(13, {arg i;
	if(~randThresholdDiff1[i] >= 1,
	{
	~randThresholdDiff1[i] = rrand(0.00, 0.50);
	}

	);
	if(~randThresholdDiff1[i] < 0,
	{
	~randThresholdDiff1[i] = rrand(0.00, 0.50);
	}
	);
	});

//send values to synths and GUI

	{
	~panners1Array = Array.fill(13, {arg i;
	~panKnob1[i].valueAction = \pan.asSpec.unmap(~randPanDiff1[i]);
	};
	);

	~onsetDurationSlider1.value = ~randDurationDiff1/10;
	~grainAttack1Slider.value = ~randDurationDiff1/10;
	~grainRelease1Slider.value = ~randDurationDiff1/10;
	~onset1DurationArray0 = Array.fill(13, {arg i;
	~granularMacroSynth1.set("onset1Duration" ++ i.asString, ~randDurationDiff1[i]);
	~envelopeSynth.set("grain1Attack" ++ i.asString, (~randDurationDiff1[i])/2.1);
	~envelopeSynth.set("grain1Release" ++ i.asString, (~randDurationDiff1[i])/2.1);
	~granularMacroSynth2.set("grain1Attack" ++ i.asString, (~randDurationDiff1[i])/2.1);
	~granularMacroSynth2.set("grain1Release" ++ i.asString, (~randDurationDiff1[i])/2.1);
	});

	~pitch1Slider0.value = ~randPitchDiff1/4;
	~pitch1Slider0Array = Array.fill(13, {arg i;
	~granularMacroSynth1.set("grain1Pitch" ++ i.asString, ~randPitchDiff1[i])});

	~grainAmplitude1Slider.value = ~randAmpDiff1;
	~grainAmplitude1Array0 = Array.fill(13, {arg i;
	~envelopeSynth.set("grain1Amplitude" ++ i.asString, ~randAmpDiff1[i])});

	~onsetThresholdSlider1.value = ~randThresholdDiff1;
	~onsetThresholdArray1 = Array.fill(13, {arg i;
	~analysisSynth.set("osc1OnsetThreshold" ++ i.asString, ~randThresholdDiff1[i])});

	}.defer;


//add changes to current data
	~smallChange1 = [rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1), rrand(-0.1, 0.1)];
	~medChange1 = [rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5), rrand(-0.5, 0.5)];
	~largeChange1 = [rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0), rrand(-1.0, 1.0)];

//wchoose amount of change
	~randPanDiff1 = [~randPanDiff1 + ~smallChange1, ~randPanDiff1 + ~medChange1, ~randPanDiff1 + ~largeChange1].wchoose(~differenceArray1);
	~randDurationDiff1 = [~randDurationDiff1 + ~smallChange1, ~randDurationDiff1 + ~medChange1, ~randDurationDiff1 + ~largeChange1].wchoose(~differenceArray1);
	~randPitchDiff1 = [~randPitchDiff1 + ~smallChange1, ~randPitchDiff1 + ~medChange1, ~randPitchDiff1 + ~largeChange1].wchoose(~differenceArray1);
	~randAmpDiff1 = [~randAmpDiff1 + ~smallChange1, ~randAmpDiff1 + ~medChange1, ~randAmpDiff1 + ~largeChange1].wchoose(~differenceArray1);
	~randThresholdDiff1 = [~randThresholdDiff1 + ~smallChange1, ~randThresholdDiff1 + ~medChange1, ~randThresholdDiff1 + ~largeChange1].wchoose(~differenceArray1);


//set duration between each change relative to control source two tempo
	~randDurationChooser1 = [0.1, 0.2, 0.33, 0.5, 0.66, 1, 2].choose;

	(~tempo1Message0*~randDurationChooser1).wait;

    });
	});

	~randRoutine1.reset;
	~randRoutine1.play;

	}

	);

	if (butt.value == 0,

	{

	~randRoutine1.stop;

	});

	});

	~panKnob1[0].action = {|v,x,y,m|
								~pan1Synth.set(
								"grain1panner0", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob1[0].valueAction  = " ++ ~panKnob1[0].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob1[1].action = {|v,x,y,m|
								~pan1Synth.set(
								"grain1panner1", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob1[1].valueAction  = " ++ ~panKnob1[1].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob1[2].action = {|v,x,y,m|
								~pan1Synth.set(
								"grain1panner2", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob1[2].valueAction  = " ++ ~panKnob1[2].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob1[3].action = {|v,x,y,m|
								~pan1Synth.set(
								"grain1panner3", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob1[3].valueAction  = " ++ ~panKnob1[3].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob1[4].action = {|v,x,y,m|
								~pan1Synth.set(
								"grain1panner4", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob1[4].valueAction  = " ++ ~panKnob1[4].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob1[5].action = {|v,x,y,m|
								~pan1Synth.set(
								"grain1panner5", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob1[5].valueAction  = " ++ ~panKnob1[5].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};
	~panKnob1[6].action = {|v,x,y,m|
								~pan1Synth.set(
								"grain1panner6", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob1[6].valueAction  = " ++ ~panKnob1[6].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob1[7].action = {|v,x,y,m|
								~pan1Synth.set(
								"grain1panner7", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob1[7].valueAction  = " ++ ~panKnob1[7].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob1[8].action = {|v,x,y,m|
								~pan1Synth.set(
								"grain1panner8", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob1[8].valueAction  = " ++ ~panKnob1[8].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob1[9].action = {|v,x,y,m|
								~pan1Synth.set(
								"grain1panner9", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob1[9].valueAction  = " ++ ~panKnob1[9].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob1[10].action = {|v,x,y,m|
								~pan1Synth.set(
								"grain1panner10", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob1[10].valueAction  = " ++ ~panKnob1[10].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob1[11].action = {|v,x,y,m|
								~pan1Synth.set(
								"grain1panner11", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob1[11].valueAction  = " ++ ~panKnob1[11].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

	~panKnob1[12].action = {|v,x,y,m|
								~pan1Synth.set(
								"grain1panner12", \pan.asSpec.map(v.value);
								);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~panKnob1[12].valueAction  = " ++ ~panKnob1[12].value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};
// create array of pan knobs for granular synthesizers triggered by control three/slave
	~panKnob2 = Array.new(13);
	~panKnob2Array0 = Array.fill(13, {arg i;
	~panKnob2.add(Knob.new(~w7, Rect(i*((1920/3.25)/13)+1280, 0, (1920/3)/20, (1920/3)/20)));

	~panKnob2[i].value_(\pan.asSpec.unmap(0));
	~panKnob2[i].skin_(GUI.skins.default.knob.center_(Color.black.alpha_(0.2)););
	~panKnob2[i].skin_(GUI.skins.default.knob.level_(Color.blue.alpha_(0.8)));
	~panKnob2[i].skin_(GUI.skins.default.knob.dial_(Color.blue.alpha_(0.8)));
	~panKnob2[i].centered_(true);
	});

// create sound file view for sample ugen of control source one
	~sampleViewer0 = SoundFileView.new(~w1, Rect(26, 26, (1920/3)-50, height-78));
	~sampleViewer0.setSelectionColor(0, Color.white.alpha_(0.8));
	~sampleViewer0.timeCursorOn = true;
	~sampleViewer0.timeCursorColor = Color.black.alpha_(0.75);
	~sampleViewer0.gridOn = false;
	~sampleViewer0.waveColors_([Color.yellow.alpha_(0.6), Color.yellow.alpha_(0.6)]);
	~sampleViewer0.background_(Color.gray.alpha_(0));
	~sampleViewer0.drawsWaveForm_(true);

	~sampleFile0 = SoundFile.new;

	~dna0 = List[];
	~dna1 = List[];
	~child = List[];

// create load path button to place audio file in sample ugens for control one
	~samplePathButton0 = Button(~w1, Rect(25, 0, (1920/3)-50, 26));
	~samplePathButton0.font_(Font("Monaco", 10));
	~samplePathButton0.states_([["Add File...", Color.black.alpha_(0.8), Color.yellow.alpha_(0.8)]]);
	~samplePathButton0.action_({
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0, i;
				c.free;
				~samplePath0 = path0;
				c.allocRead(~samplePath0.asString);
				~sampleFile0.openRead(~samplePath0.asString);
				~sampleViewer0.soundfile = ~sampleFile0;
				~sampleViewer0.read(0, ~sampleFile0.numFrames);
				~sampleViewer0.refresh;
				~cnumFrames = ~sampleFile0.numFrames;
				~samplePathButton0.states_([[~samplePath0.asString, Color.black.alpha_(0.5), Color.yellow.alpha_(0.8)]]);
				~bufferSynth.set(\start0, 0, \end0, ~sampleFile0.numFrames);
				~dna0.add(1);
				~attackText0[21].string_(~dna0.size.asString);
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~samplePath0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
			})
		},{
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Cancelled File Opening ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
		});
	});


// create loop button for sample ugens for control one
	~loop0Button0 = Button(~w1, Rect(25, 300-26, (((1920/3)/2)-25), 26));
	~loop0Button0.font_(Font("Monaco", 10));
	~loop0Button0.states_([
					["Play File Length",Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)]
							]);
	~loop0Button0.mouseDownAction_({
	~bufferSynth.set(\start0, 0, \end0, ~sampleFile0.numFrames);
	~sampleViewer0.setSelectionSize(0, 0);
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Playing File Length ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});


// create trigger button for control one
	~triggerButton0 = Button(~w1, Rect(25 + (((1920/3)/2)-25), 300-26, (((1920/3)/2)-25), 26));
	~triggerButton0.font_(Font("Monaco", 10));
	~triggerButton0.states_([
					["Click To Trigger...",Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["Click To Trigger On",Color.yellow.alpha_(0.8),Color.white.alpha_(0.4)],
					]);

// set buffer frames selection process
	~sampleViewer0.mouseUpAction_({arg view;
		var where;
		where = (view.selections[0]);
		~bufferSynth.set(\start0, where[0], \end0, where[0]+where[1]);
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Playing from " ++ where[0].asString ++ " to " ++ (where[0]+where[1]).asString, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{~bufferSynth.set(\"start0\"," ++ where[0].value.asString ++ "," ++ " \"end0\", " ++ (where[0]+where[1]).value.asString ++ ");}.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
	});

// zoom sample file of control one
	~zoom0Slider0 = EZSlider(~w1, Rect(0, 0, 26, 300), "Zoom", volume1Spec0, initVal:1, unitWidth:0, numberWidth:0, layout:\vert);
	~zoom0Slider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.yellow.alpha_(0.8), Color.clear);
	~zoom0Slider0.font_(Font("Monaco", 10));
	~zoom0Slider0.action = {|ez|
								~sampleViewer0.zoomToFrac(ez.value).refresh;
								};
// scroll sample file of control one
	~scroll0Slider0 = EZSlider(~w1, Rect(0, 300-52, (1920/3)-26, 26), "Scroll", volume1Spec0, initVal:0.5, unitWidth:0, numberWidth:0, layout:\horz);
	~scroll0Slider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.yellow.alpha_(0.8), Color.clear);
	~scroll0Slider0.font_(Font("Monaco", 8));
	~scroll0Slider0.action = {|ez|
								~sampleViewer0.scrollTo(ez.value).refresh;
								};

// create sound file view for sample ugen of control source two
	~sampleViewer1 = SoundFileView.new(~w1, Rect((640)+25, 26, (1920/3)-50, height-78));
	~sampleViewer1.setSelectionColor(0, Color.white.alpha_(0.8));
	~sampleViewer1.timeCursorOn = true;
	~sampleViewer1.timeCursorColor = Color.black.alpha_(0.75);
	~sampleViewer1.gridOn = false;
	~sampleViewer1.waveColors_([Color.red.alpha_(0.6), Color.red.alpha_(0.6)]);
	~sampleViewer1.background_(Color.gray.alpha_(0));
	~sampleViewer1.drawsWaveForm_(true);

	~sampleFile1 = SoundFile.new;

// create load path button to place audio file in sample ugens for control two
	~samplePathButton1 = Button(~w1, Rect((640)+25, 0, (1920/3)-50, 26));
	~samplePathButton1.font_(Font("Monaco", 10));
	~samplePathButton1.states_([["Add File...", Color.white, Color.red.alpha_(0.8)]]);
	~samplePathButton1.action_({
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
				d.free;
				~samplePath1 = path0;
				d.allocRead(~samplePath1.asString);
				~sampleFile1.openRead(~samplePath1.asString);
				~sampleViewer1.soundfile = ~sampleFile1;
				~sampleViewer1.read(0, ~sampleFile1.numFrames);
				~sampleViewer1.refresh;
				~dnumFrames = ~sampleFile1.numFrames;
				~samplePathButton1.states_([[~samplePath1.asString, Color.white, Color.red.alpha_(0.8)]]);
				~bufferSynth.set(\start1, 0, \end1, ~sampleFile1.numFrames);
				~dna1.add(1);
				~attackText0[22].string_(~dna1.size.asString);
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~samplePath1.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
			})
		},{
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Cancelled File Opening ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
		});
	});

// create loop button for sample ugens for control two
	~loop1Button0 = Button(~w1, Rect(640+25, 300-26, ((1920/3/2)-25), 26));
	~loop1Button0.font_(Font("Monaco", 10));
	~loop1Button0.states_([
					["Play File Length",Color.white,Color.red.alpha_(0.8)]
							]);
	~loop1Button0.mouseDownAction_({
	~bufferSynth.set(\start1, 0, \end1, ~sampleFile1.numFrames);
	~sampleViewer1.setSelectionSize(0, 0);
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Playing File Length ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});

// create trigger button for control two
	~triggerButton1 = Button(~w1, Rect((640+25) + ((1920/3/2)-25), 300-26, ((1920/3/2)-25), 26));
	~triggerButton1.font_(Font("Monaco", 10));
	~triggerButton1.states_([
					["Click To Trigger...",Color.white,Color.red.alpha_(0.8)],
					["Click To Trigger On",Color.red.alpha_(0.8),Color.white.alpha_(0.4)],
							]);

// set buffer frames selection process
	~sampleViewer1.mouseUpAction_({arg view;
		var where;
		where = (view.selections[0]);
		~bufferSynth.set(\start1, where[0], \end1, where[0]+where[1]);
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Playing from " ++ where[0].asString ++ " to " ++ (where[0]+where[1]).asString, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{~bufferSynth.set(\"start1\"," ++ where[0].value.asString ++ "," ++ " \"end1\", " ++ (where[0]+where[1]).value.asString ++ ");}.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
	});

// zoom sample file of control two
	~zoom1Slider0 = EZSlider(~w1, Rect(640, 0, 26, 300), "Zoom", volume1Spec0, initVal:1, unitWidth:0, numberWidth:30, layout:\vert);
	~zoom1Slider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.red.alpha_(0.8), Color.clear);
	~zoom1Slider0.font_(Font("Monaco", 10));
	~zoom1Slider0.action = {|ez|
								~sampleViewer1.zoomToFrac(ez.value).refresh;
								};

// scroll sample file of control two
	~scroll1Slider0 = EZSlider(~w1, Rect(640, 300-52, (1920/3)-26, 26), "Scroll", volume1Spec0, initVal:0.5, unitWidth:0, numberWidth:0, layout:\horz);
	~scroll1Slider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.red.alpha_(0.8), Color.clear);
	~scroll1Slider0.font_(Font("Monaco", 8));
	~scroll1Slider0.action = {|ez|
								~sampleViewer1.scrollTo(ez.value).refresh;
								};

// create sound file view for sample ugen of control source three/slave
	~sampleViewer2 = SoundFileView.new(~w1, Rect(1280+25, 26, (1920/3)-50, height-78));
	~sampleViewer2.setSelectionColor(0, Color.white.alpha_(0.8));
	~sampleViewer2.timeCursorOn = true;
	~sampleViewer2.timeCursorColor = Color.black.alpha_(0.75);
	~sampleViewer2.gridOn = false;
	~sampleViewer2.waveColors_([Color.blue.alpha_(0.6), Color.blue.alpha_(0.6)]);
	~sampleViewer2.background_(Color.gray.alpha_(0));
	~sampleViewer2.drawsWaveForm_(true);

// select trigger source of slave envelope
	~chooseTriggerButton0 = PopUpMenu(~w5, Rect(300, 250, 200, 25));
	~chooseTriggerButton0.font_(Font("Monaco", 10));
	~chooseTriggerButton0.items = ["Manual","DNA0 Trigger","DNA1 Trigger","child Trigger"];
	~chooseTriggerButton0.value = 1;
	~chooseTriggerButton0.action_({arg menu;
	~bufferSynth.set(\triggerChooser, menu.value);
	if (menu.value == 0,
	{~bufferSynth.set(\amplitudeChooser0, 0); ~chooseTriggerButton0.background_(Color.blue); ~w1.refresh; ~triggerButton2.valueAction = 0;
	~triggerButton2.states_([["Click To Trigger...",Color.white,Color.blue.alpha_(0.8)],["Click Trigger On",Color.blue.alpha_(0.8),Color.white.alpha_(0.4)],]);
	~chooseTriggerButton0.stringColor_(Color.white); ~chooseOnsetsButton0.background_(Color.blue);
	~chooseOnsetsButton0.stringColor_(Color.white);
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Trigger is Manual ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});
	if (menu.value == 1,
	{~bufferSynth.set(\amplitudeChooser0, 1);  ~triggerButton2.valueAction = 0;
	~triggerButton2.states_([["DNA0 Trigger is ON",Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],["DNA0 Trigger is ON",Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],]); ~w1.refresh;
	 ~chooseTriggerButton0.background_(Color.yellow); ~chooseTriggerButton0.stringColor_(Color.black); ~chooseOnsetsButton0.background_(Color.yellow); ~chooseOnsetsButton0.stringColor_(Color.black);
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " DNA0 Trigger Onset " ++ ~chooseOnsetsButton0.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});
	if (menu.value == 2,
	{~bufferSynth.set(\amplitudeChooser0, 2);  ~triggerButton2.valueAction = 0;
	~triggerButton2.states_([["DNA1 Trigger is ON",Color.black.alpha_(0.8),Color.red.alpha_(0.8)],["DNA1 Trigger is ON",Color.black.alpha_(0.8),Color.red.alpha_(0.8)],]); ~w1.refresh;
	~chooseTriggerButton0.background_(Color.red); ~chooseTriggerButton0.stringColor_(Color.black); 	~chooseOnsetsButton0.background_(Color.red); ~chooseOnsetsButton0.stringColor_(Color.black);
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " DNA1 Trigger Onset " ++ ~chooseOnsetsButton0.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});
	if (menu.value == 3,
	{~bufferSynth.set(\amplitudeChooser0, 3);  ~triggerButton2.valueAction = 0;
	~triggerButton2.states_([["Child Trigger is ON",Color.white,Color.blue.alpha_(0.8)],["Child Trigger is ON",Color.white,Color.blue.alpha_(0.8)],]); ~w1.refresh;
	~chooseTriggerButton0.background_(Color.blue); ~chooseTriggerButton0.stringColor_(Color.white); 	~chooseOnsetsButton0.background_(Color.blue); ~chooseOnsetsButton0.stringColor_(Color.white);
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " child Trigger Onset " ++ ~chooseOnsetsButton0.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});

	});
	~chooseTriggerButton0.background_(Color.yellow.alpha_(0.8));
	~chooseTriggerButton0.stringColor_(Color.black.alpha_(0.8));

// select specific onset for trigger
	~chooseOnsetsButton0 = PopUpMenu(~w5, Rect(500, 250, 200, 25));
	~chooseOnsetsButton0.font_(Font("Monaco", 10));
	~chooseOnsetsButton0.items = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"];
	~chooseOnsetsButton0.action_({arg menu;
	~bufferSynth.set(\onsetChooser, menu.value);

	if(~chooseTriggerButton0.value == 0,
	{
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~chooseTriggerButton0.items[~chooseTriggerButton0.value] ++ " Onset " ++ ~chooseOnsetsButton0.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});

	if(~chooseTriggerButton0.value == 1,
	{
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~chooseTriggerButton0.items[~chooseTriggerButton0.value] ++ " Onset " ++ ~chooseOnsetsButton0.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});

	if(~chooseTriggerButton0.value == 2,
	{
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~chooseTriggerButton0.items[~chooseTriggerButton0.value] ++ " Onset " ++ ~chooseOnsetsButton0.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});

	if(~chooseTriggerButton0.value == 3,
	{
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~chooseTriggerButton0.items[~chooseTriggerButton0.value] ++ " Onset " ++ ~chooseOnsetsButton0.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});

	});

	~chooseOnsetsButton0.background_(Color.yellow.alpha_(0.8));
	~chooseOnsetsButton0.stringColor_(Color.black.alpha_(0.8));

	~sampleFile2 = SoundFile.new;

// create load path button to place audio file in sample ugens for control two
	~samplePathButton2 = Button(~w1, Rect(1280+25, 0, (1920/3)-50, 26));
	~samplePathButton2.font_(Font("Monaco", 10));
	~samplePathButton2.states_([["Add File..", Color.white, Color.blue.alpha_(0.8)]]);
	~samplePathButton2.action_({
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
				b.free;
				~samplePath2 = path0;
				b.allocRead(~samplePath2.asString);
				~sampleFile2.openRead(~samplePath2.asString);
				~sampleViewer2.soundfile = ~sampleFile2;
				~sampleViewer2.read(0, ~sampleFile2.numFrames);
				~sampleViewer2.refresh;
				~bnumFrames = ~sampleFile2.numFrames;
				~samplePathButton2.states_([[~samplePath2.asString, Color.white, Color.blue.alpha_(0.8)]]);
				~bufferSynth.set(\start2, 0, \end2, ~sampleFile2.numFrames);
				~start = 0;
				~length = ~sampleFile2.numFrames;
				~child.add(1);
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~samplePath2.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
			})
		},{
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Cancelled File Opening ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
		});
	});

// set buffer frames selection process
	~sampleViewer2.mouseUpAction_({arg view;
		var where;
		where = (view.selections[0]);
		~bufferSynth.set(\start2, where[0], \end2, where[0]+where[1]);
		~start = where[0];
		~length = where[0]+where[1];
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Playing from " ++ where[0].asString ++ " to " ++ (where[0]+where[1]).asString, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{~bufferSynth.set(\"start2\"," ++ where[0].value.asString ++ "," ++ " \"end2\", " ++ (where[0]+where[1]).value.asString ++ ");}.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
	});

// create loop button for sample ugens for control three/slave
	~loop2Button0 = Button(~w1, Rect(1280+25, 300-26, ((1920/3/2)-25), 26));
	~loop2Button0.font_(Font("Monaco", 10));
	~loop2Button0.states_([
					["Play File Length",Color.white,Color.blue.alpha_(0.8)]
							]);
	~loop2Button0.mouseDownAction_({
	~bufferSynth.set(\start2, 0, \end2, ~sampleFile2.numFrames);
	~sampleViewer2.setSelectionSize(0, 0);
	~start = 0;
	~length = ~sampleFile2.numFrames;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Playing File Length ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});

// create trigger button for control three/slave
	~triggerButton2 = Button(~w1, Rect((1280+25) + ((1920/3/2)-25), 300-26, ((1920/3/2)-25), 26));
	~triggerButton2 .font_(Font("Monaco", 10));
	~triggerButton2.states_([["DNA0 Trigger is ON",Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],["DNA0 Trigger is ON",Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],]);

// zoom sample file of control three/slave
	~zoom2Slider0 = EZSlider(~w1, Rect(1280, 0, 26, 300), "Zoom", volume1Spec0, initVal:1, unitWidth:0, numberWidth:30, layout:\vert);
	~zoom2Slider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.blue.alpha_(0.8), Color.clear);
	~zoom2Slider0.font_(Font("Monaco", 10));
	~zoom2Slider0.action = {|ez|
								~sampleViewer2.zoomToFrac(ez.value).refresh;
								};

// scroll sample file of control three/slave
	~scroll2Slider0 = EZSlider(~w1, Rect(1280, 300-52, (1920/3)-26, 26), "Scroll", volume1Spec0, initVal:0.5, unitWidth:0, numberWidth:0, layout:\horz);
	~scroll2Slider0.setColors(Color.clear, Color.white, Color.clear, Color.clear, Color.white, Color.white, 	Color.white, Color.blue.alpha_(0.8), Color.clear);
	~scroll2Slider0.font_(Font("Monaco", 8));
	~scroll2Slider0.action = {|ez|
								~sampleViewer2.scrollTo(ez.value).refresh;
								};

// toggle pitch setting of slave for pitch following process between fixed or pitch of input
	~pitchFixedButton0 = Button(~w5, Rect(200, 150, 50, 25));
	~pitchFixedButton0.font_(Font("Monaco", 10));
	~pitchFixedButton0.states_([
					["Input",Color.white.alpha_(0.8), Color.blue.alpha_(0.8)],
					["Fixed",Color.blue.alpha_(0.8), Color.white.alpha_(0.8)],
							]);

// display text of current input for control one
	~attackText0[23] = StaticText(~w1, Rect(26, 26, (1920/3)-50, height-78));
	~attackText0[23].string_("sample on");
	~attackText0[23].stringColor_(Color.yellow.alpha_(0.5));
	~attackText0[23].font_(Font("Monaco", 50));

// display text of current input for control two
	~onText0 = StaticText(~w1, Rect((640)+25, 26, (1920/3)-50, height-78));
	~onText0.string_("sample on");
	~onText0.stringColor_(Color.red.alpha_(0.5));
	~onText0.font_(Font("Monaco", 50));

// display text of current input for control three
	~attackText0[24] = StaticText(~w1, Rect(1280+25, 26, (1920/3)-50, height-78));
	~attackText0[24].string_("sample on");
	~attackText0[24].stringColor_(Color.blue.alpha_(0.5));
	~attackText0[24].font_(Font("Monaco", 50));

// display name of synthdef for control one	(if applicable)
	~synthText0 = StaticText(~w1, Rect(26, 60, (1920/3)-50, height-138));
	~synthText0.string_("");
	~synthText0.stringColor_(Color.black);
	~synthText0.font_(Font("Monaco", 25));

// display name of synthdef for control two	(if applicable)
	~synthText1 = StaticText(~w1, Rect((640)+25, 60, (1920/3)-50, height-138));
	~synthText1.string_("");
	~synthText1.stringColor_(Color.black);
	~synthText1.font_(Font("Monaco", 25));

// display name of synthdef for control three/slave	(if applicable)
	~synthText2 = StaticText(~w1, Rect(1280+25, 60, (1920/3)-50, height-138));
	~synthText2.string_("");
	~synthText2.stringColor_(Color.black);
	~synthText2.font_(Font("Monaco", 25));

// set fixed pitch of slave to midi note value for pitch following process
	~pitchFixed0 = TextField(~w5, Rect(250, 150, 50, 25));
	~pitchFixed0.font_(Font("Monaco", 10));
	~pitchFixed0.string = "A2";
	~pitchFixed0.action = {arg field;
		~bufferSynth.set(\fixedPitch, field.value.namemidi.midicps);
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Fundamental Pitch Set to "  ++  field.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));									~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~pitchFixed0.valueAction = " ++ field.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);};

// generate scales for pitch fixing process
	~scaleFunctions = [(0..10).collect({|n| (Scale.major.degrees+(12 * n))}).flatten, (0..10).collect({|n| 	(Scale.minor.degrees+(12 * n))}).flatten, (0..10).collect({|n| (Scale.chromatic.degrees+(12 * n))}).flatten];
	~chosenScale = ~scaleFunctions.at(0);
	~chosenScaleAdjust = ~chosenScale - 1;

// set root note of scale
	~noteText = PopUpMenu(~w5, Rect(15, 200, 75, 25));
	~noteText.font_(Font("Monaco", 10));
	~noteText.items = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
	~noteText.action = {arg menu;
	~chosenScaleAdjust = (~chosenScale + menu.value);
	~scaleOnButton.valueAction = 0;
	~scaleOnButton.valueAction = 1;
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Scale is " ++ ~noteText.items[~noteText.value].asString ++ " "  ++ ~scaleSelect0.items[~scaleSelect0.value].asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
			~scaleView.string = ~noteText.items[~noteText.value].asString ++ " "  ++ ~scaleSelect0.items[~scaleSelect0.value].asString;
		~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~noteText.valueAction = " ++ ~noteText.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	};

// text for current scale
	~scaleView = StaticText(~w5, Rect(100, 250, 400, 50));
	~scaleView.string = "C Major";
	~scaleView.font = Font("Monaco", 18);

// set scale form
	~scaleSelect0 = PopUpMenu(~w5, Rect(15, 225, 75, 25));
	~scaleSelect0.font_(Font("Monaco", 10));
	~scaleSelect0.items = ["Major", "Minor", "Chromatic"];

	~scaleSelect0.action = {arg menu;
	~chosenScale = (~scaleFunctions.at(menu.value)) + ~noteText.value;
	~chosenScaleAdjust = ~chosenScale - 1;
	~scaleOnButton.valueAction = 0;
	~scaleOnButton.valueAction = 1;
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~scaleSelect0.valueAction = " ++ ~scaleSelect0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~scaleView.string = ~noteText.items[~noteText.value].asString ++ " "  ++ ~scaleSelect0.items[~scaleSelect0.value].asString;
		};

// toggle pitch fix process
	~scaleOnButton = Button(~w5, Rect(15, 250, 75, 25));
	~scaleOnButton.font_(Font("Monaco", 10));
	~scaleOnButton.states_([
					["Stopped",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Playing",Color.black.alpha_(0.8),Color.green.alpha_(0.8)],
							]);

	~scaleOnButton.action_({arg butt;
	if ( (butt.value == 1),
	{	~bufferSynth.set(\scaleChooser, 1);
		~scaleBuffer = Buffer(s, ~chosenScaleAdjust.size, 1, bufnum:900);
		s.listSendMsg(~scaleBuffer.allocMsg(~scaleBuffer.setnMsg(0, ~chosenScaleAdjust.midicps)));
		~pitchTrackerSynth = Synth(\scaler);
		~pitchTrackerSynth.set(\bufnum, ~scaleBuffer);
		~scalerUpdateRoutine0.reset;
		~scalerUpdateRoutine0.play;
		~scaleOnButton.states_([
					["Stopped",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Playing",Color.black.alpha_(0.8),Color.green.alpha_(0.8)],
							]);
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Scaler Started "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
			~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~scaleOnButton.valueAction = " ++ ~scaleOnButton.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
		},
	{~bufferSynth.set(\scaleChooser, 0); ~scalerUpdateRoutine0.stop; ~pitchTrackerSynth.free;
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Scaler Stopped "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);		}
	);

	});

// text view of input pitch of pitch fix process
	~noteView0 = StaticText(~w5, Rect(250, 225, 50, 50));
	~noteView0.font = Font("Monaco", 30);

	~inView0 = StaticText(~w5, Rect(100, 225, 50, 50));
	~inView0 .string = "in";
	~inView0.font = Font("Monaco", 25);

// text view of output pitch of pitch fix process
	~noteView1 = StaticText(~w5, Rect(150, 225, 50, 50));
	~noteView1.font = Font("Monaco", 30);

	~outView0 = StaticText(~w5, Rect(200, 225, 50, 50));
	~outView0 .string = "out";
	~outView0.font = Font("Monaco", 25);

// post window for Genesis
	~textEditor = Document.new("Code");
	~textEditor.bounds_(Rect(0, 0, (1920/4), 316));
	~textEditor.background = Color.gray.alpha_(0);
	~textEditor.font = Font("Monaco", 10);

// default live coding GUI routine name
	~saveName = "~routine";

// hidden window for live coding GUI method
	~saveText = Document.new("Save Session", makeListener: false);
	~saveText.bounds_(Rect((1920/3), 456, 1920/3, 230));
	~saveText.background = Color.gray.alpha_(0);
	~saveText.font = Font("Monaco", 10);
	~saveText.editable = true;
	~saveText.string_(~saveName ++ " = Routine({

	inf.do ({ arg i; ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);

	~taskString = " \n\n " ++ "

0.01.wait;

});

});";
	~saveText.editable =  false;

// set loop type for sample ugens of control one
	~loopChoose0 = PopUpMenu(~w1, Rect(25, 300, 590, 20));
	~loopChoose0.font_(Font("Monaco", 10));
	~loopChoose0.items = ["Loop Off", "Loop Forward", "Loop Around"];
	~loopChoose0.value = 0;
	~loopChoose0.background_(Color.yellow.alpha_(0.8));
	~loopChoose0.stringColor_(Color.black.alpha_(0.8));
	~loopChoose0.action = {arg menu;
			~bufferSynth.set(\loopOn0, menu.value);
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " "  ++  ~loopChoose0.items[~loopChoose0.value].asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

	};

// set loop type for sample ugens of control two
	~loopChoose1 = PopUpMenu(~w1, Rect(1920/3 + 25, 300, 590, 20));
	~loopChoose1.font_(Font("Monaco", 10));
	~loopChoose1.items = ["Loop Off", "Loop Forward", "Loop Around"];
	~loopChoose1.value = 0;
	~loopChoose1.background_(Color.red.alpha_(0.8));
	~loopChoose1.stringColor_(Color.white);
	~loopChoose1.action = {arg menu;
	~bufferSynth.set(\loopOn1, menu.value);
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " "  ++  ~loopChoose1.items[~loopChoose1.value].asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};

// set loop type for sample ugens of control three/slave
	~loopChoose2 = PopUpMenu(~w1, Rect(1920/1.5 +25, 300, 590, 20));
	~loopChoose2.font_(Font("Monaco", 10));
	~loopChoose2.items = ["Loop Off", "Loop Forward", "Loop Around"];
	~loopChoose2.value = 0;
	~loopChoose2.background_(Color.blue.alpha_(0.8));
	~loopChoose2.stringColor_(Color.white);
	~loopChoose2.action = {arg menu;
			~bufferSynth.set(\loopOn2, menu.value);
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " "  ++  ~loopChoose2.items[~loopChoose2.value].asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};

// clock default values
~clockOn0 = 0;
~clockOut = "Clock Not Started";
~syncSelector0 = 0;
~systemNumber0 = 0;
~clockGUI = 0.asInteger;

~clockMinutes = 1;
~clockSeconds = 0;
~clockOutSeconds = 0.asSymbol;
~clockOutMinutes = 0.asSymbol;

// clock counter task for seconds and minutes
~clockTask = Task.new({

	inf.do({ |i|

			var min, secs, timeCompare;
			 secs = (( i + ~clockSeconds) % 60);
			 timeCompare = (~clockMinutes + (~clockSeconds/60));

                min = (((i / 60)  + (timeCompare-1)).max(0)).asInteger;

                if (secs < 10, {secs = (0.asSymbol ++ secs.asSymbol)});

			~clockOutSeconds = secs.asSymbol;
			~clockOutMinutes = min.asSymbol;

        1.wait;
        })

});

// clock counter task for hundredths
~clockTaskHundreths = Task.new({

	inf.do({ |i|

			var min, secs;
			 secs = (( (i)) % 100).round(0.01);

			if (secs < 10, {secs = (0.asSymbol ++ secs.asSymbol)});

			~clockOutHundreths = secs;

               {~clockText.string = [(~clockOutMinutes ++ " " ++ ~clockOutSeconds ++ " " ++ ~clockOutHundreths), ~clockReply0[1].asString].at(~syncSelector0);}.defer;
			~clockOut = [(~clockOutMinutes ++ " " ++ ~clockOutSeconds ++ " " ++ ~clockOutHundreths).asString, ~clockReply0[1].asString].at(~syncSelector0);
			~clockGUI = [(~clockOutMinutes ++  ~clockOutSeconds ++ ~clockOutHundreths).asInteger, ~clockReply0[2].asInteger].at(~syncSelector0);

       (1/100).wait;
        })

});

// clock counter text
~clockText = StaticText(~w6, Rect(25, 0, 200, 25));
~clockText.background = Color.white.alpha_(0.5);
~clockText.align = \center;
~clockText.font = Font("Monaco", 20);
~clockText.string = "0 00 00";

// clock counter dividers
~clockTextDivider = StaticText(~w6, Rect(25, 0, 200, 25));
~clockTextDivider.background = Color.white.alpha_(0);
~clockTextDivider.align = \center;
~clockTextDivider.font = Font("Monaco", 20);
~clockTextDivider.string = ":  : ";

// toggle clock start button
~clockStart = Button(~w6, Rect(225, 0, 100, 25));
~clockStart.font = Font("Monaco", 10);
        ~clockStart.states = ([["Start",Color.white.alpha_(0.8), Color.red.alpha_(0.7)],["Pause",Color.black, Color(0.35, 0.35, 0.6)]]);
        ~clockStart.action = ( { case {~clockStart.value == 1} {~clockTask.play; syncOut = 2; ~clockTaskHundreths.play; ~clockOn0 = 1;};
            case {~clockStart.value == 0} {~clockTask.pause; ~clockTaskHundreths.pause; ~clockOut = "Clock Paused"; syncOut = 0; ~clockOn0 = 0;};} );

~clockStop = Button(~w6, Rect(325, 0, 50, 25));
~clockStop.font = Font("Monaco", 10);
        ~clockStop.states = ([["Reset..",Color.black.alpha_(0.8), Color.green.alpha_(0.3)], ["Reset!!!",Color.black, Color(0.35, 0.35, 0.6)]]);
        ~clockStop.action = ( { case {~clockStop.value == 1} {
	~clockOn0 = 0;
	~editButton.valueAction = 0;
	~newTaskButton0.valueAction = 0;
	~newTaskButton1.valueAction = 0;
	~newTaskButton2.valueAction = 0;
	~newTaskButton3.valueAction = 0;
	~newTaskButton4.valueAction = 0;
	~newTaskButton5.valueAction = 0;
	~newTaskButton6.valueAction = 0;
	~newTaskButton7.valueAction = 0;
	~newTaskButton8.valueAction = 0;
	~newTaskButton9.valueAction = 0;
	~newTaskButton10.valueAction = 0;
	~newTaskButton11.valueAction = 0;
	~newTaskButton12.valueAction = 0;
	~newTaskButton13.valueAction = 0;
	~newTaskButton14.valueAction = 0;
	~clockStart.value = 0;
	~clockTaskHundreths.reset;
	~clockTaskHundreths.stop;
	~clockTask.reset;
	~clockTask.stop;
	~clockText.string = "0 00 00";
	~clockGUI = 0.asInteger;
	~clockOut = "Clock Not Started";
	syncOut = 1;

			};

	  case {~clockStop.value == 0} {syncOut = 4; ~clockTaskHundreths.reset; ~clockTask.reset; ~clockTask.stop; ~clockTaskHundreths.stop;
	~clockOn0 = 0;
	~editButton.valueAction = 0;
	~clockText.string = "0 00 00";
	~clockGUI = 0.asInteger;
	~clockOut = "Clock Not Started"; };
} );

// network clock syncing task
~clockSyncTask = Task({
		inf.do({arg i;

	 if(~clockReply0[0] == 0,
	{{~clockStop.value = 0; ~clockStart.valueAction = 0;}.defer; });

	 if(~clockReply0[0] == 1,
	{{~clockStop.valueAction = 1; ~clockStart.value = 0;}.defer; });

	 if(~clockReply0[0] == 2,
	{{~clockStart.valueAction = 1;  ~clockStop.value = 0;}.defer; });

	 if(~clockReply0[0] == 4,
	{{~clockStart.value = 0;  ~clockStop.value = 0;}.defer; });

	0.01.wait;

	});
	}).stop;

// toggle network clock syncing
~clockSyncIn = Button(~w6, Rect(375, 0, 50, 25));
~clockSyncIn.font = Font("Monaco", 8.5);
        ~clockSyncIn.states = ([["Sync Off", Color.white, Color.black.alpha_(0.8)], ["Sync On", Color.black.alpha_(0.8), Color.white]]);
        ~clockSyncIn.action_({arg butt;

	if (butt.value == 0 && (~receiverButton.value == 1),
	{
	~syncSelector0 = 0;
	~clockSyncTask.stop;
	~clockStop.valueAction = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Local Clock ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

	});

	if (butt.value == 0 && (~receiverButton.value == 0),
	{
	~syncSelector0 = 0;
	~clockSyncTask.stop;
	~clockStop.valueAction = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Local Clock ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

	});

	if((butt.value == 1) && (~receiverButton.value == 1),

	{
	~syncSelector0 = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Clock Is Synced ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~clockStop.valueAction = 0;
	~clockSyncTask.play;

	});

	if((butt.value == 1) && (~receiverButton.value == 0),

	{
	~syncSelector0 = 0;
	~clockSyncTask.stop;
	~clockStop.valueAction = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " No Incoming Network Connection for Syncing ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});


	});

// network connection checker routines

	~networkCounter0 = 0;
	~networkCounter1 = 0;
	~networkOut0 = 0;
	~networkCounterIn00 = 0;
	~networkCounterIn10 = 0;
	~networkCounterIn01 = 0;
	~networkCounterIn11 = 0;
	~networkCounterIn02 = 0;
	~networkCounterIn12 = 0;
	~networkCounterIn03 = 0;
	~networkCounterIn13 = 0;
	~networkCounterIn04 = 0;
	~networkCounterIn14 = 0;
	~networkCounterIn05 = 0;
	~networkCounterIn15 = 0;
	~networkCounterIn06 = 0;
	~networkCounterIn16 = 0;
	~networkCounterIn07 = 0;
	~networkCounterIn17 = 0;
	~networkIn0 = 0;
	~networkReceived0 = [0];
	~networkReceived1 = [0];
	~networkReceived2 = [0];
	~networkReceived3 = [0];
	~networkReceived4 = [0];
	~networkReceived5 = [0];
	~networkReceived6 = [0];
	~networkReceived7 = [0];


	~networkCheckRoutine0 = Routine.new({
    inf.do({ arg i;
		~networkOut0 = i;
		~networkCounter0 = ~pitchReply0[2];
		if ( ~networkCounter0 > ~networkCounter1,
		{{~receiverButton.value = 1;}.defer},
		{{~receiverButton.value = 0;}.defer}
		);
				1.wait;
		~networkCounter1 = ~networkCounter0;
    });
	});

	~networkCheckRoutine1 = Routine.new({
    inf.do({ arg i;
		~networkIn0 = i;

		~networkCounterIn00 = ~networkReceived0[0];
		~networkCounterIn01 = ~networkReceived1[0];
		~networkCounterIn02 = ~networkReceived2[0];
		~networkCounterIn03 = ~networkReceived3[0];
		~networkCounterIn04 = ~networkReceived4[0];
		~networkCounterIn05 = ~networkReceived5[0];
		~networkCounterIn06 = ~networkReceived6[0];
		~networkCounterIn07 = ~networkReceived7[0];

		if ( ~networkCounterIn00 > ~networkCounterIn10,
		{{~receiverButton1.value = 1;}.defer;},
		{{~receiverButton1.value = 0;}.defer;}
		);

		if ( ~networkCounterIn01 > ~networkCounterIn11,
		{{~receiverButton2.value = 1;}.defer;},
		{{~receiverButton2.value = 0;}.defer;}
		);

		if ( ~networkCounterIn02 > ~networkCounterIn12,
		{{~receiverButton3.value = 1;}.defer;},
		{{~receiverButton3.value = 0;}.defer;}
		);

		if ( ~networkCounterIn03 > ~networkCounterIn13,
		{{~receiverButton4.value = 1;}.defer;},
		{{~receiverButton4.value = 0;}.defer;}
		);

		if ( ~networkCounterIn04 > ~networkCounterIn14,
		{{~receiverButton5.value = 1;}.defer;},
		{{~receiverButton5.value = 0;}.defer;}
		);

		if ( ~networkCounterIn05 > ~networkCounterIn15,
		{{~receiverButton6.value = 1;}.defer;},
		{{~receiverButton6.value = 0;}.defer;}
		);

		if ( ~networkCounterIn06 > ~networkCounterIn16,
		{{~receiverButton7.value = 1;}.defer;},
		{{~receiverButton7.value = 0;}.defer;}
		);

		if ( ~networkCounterIn07 > ~networkCounterIn17,
		{{~receiverButton8.value = 1;}.defer;},
		{{~receiverButton8.value = 0;}.defer;}
		);

		1.wait;

		~networkCounterIn10 = ~networkCounterIn00;
		~networkCounterIn11 = ~networkCounterIn01;
		~networkCounterIn12 = ~networkCounterIn02;
		~networkCounterIn13 = ~networkCounterIn03;
		~networkCounterIn14 = ~networkCounterIn04;
		~networkCounterIn15 = ~networkCounterIn05;
		~networkCounterIn16 = ~networkCounterIn06;
		~networkCounterIn17 = ~networkCounterIn07;

    });
	});


// envelope following routines
	~envelopeRoutine0 = Routine.new({
	inf.do({ arg i;
		c0 = c0 + attack00;
		e0 = e0 + attack01;
		g0 = g0 + attack02;
		0.01.wait;
	});
	});

	~c00 = 0;
	~e00 = 0;
	~g00 = 0;
	~thresholdOut0 = 0;
	~thresholdOut1 = 0;

	~envelopeRoutine1 = Routine.new({
	inf.do({ arg i;
		~c00 = ~c00 - c0;
		~c00 = c0;
		case
		{~c00 >= 750}
		{~bufferSynth.set(\attack0, 0.01); ~bufferSynth.set(\release0, 0.01); ~thresholdOut0 = 0;}
		{~c00 >= 687.5}
		{~bufferSynth.set(\attack0, 0.025); ~bufferSynth.set(\release0, 0.025); ~thresholdOut0 = 0.1;}
		{~c00 >= 625}
		{~bufferSynth.set(\attack0, 0.05); ~bufferSynth.set(\release0, 0.05); ~thresholdOut0 = 0.2;}
		{~c00 >= 562.5}
		{~bufferSynth.set(\attack0, 0.075); ~bufferSynth.set(\release0, 0.075); ~thresholdOut0 = 0.3;}
		{~c00 >= 500}
		{~bufferSynth.set(\attack0, 0.1); ~bufferSynth.set(\release0, 0.1); ~thresholdOut0 = 0.4;}
		{~c00 >= 437.5}
		{~bufferSynth.set(\attack0, 0.25); ~bufferSynth.set(\release0, 0.25); ~thresholdOut0 = 0.5;}
		{~c00 >= 375}
		{~bufferSynth.set(\attack0, 0.3); ~bufferSynth.set(\release0, 0.3); ~thresholdOut0 = 0.6;}
		{~c00 >= 312.5}
		{~bufferSynth.set(\attack0, 0.4); ~bufferSynth.set(\release0, 0.4); ~thresholdOut0 = 0.7;}
		{~c00 >= 250}
		{~bufferSynth.set(\attack0, 0.5); ~bufferSynth.set(\release0, 0.5); ~thresholdOut0 = 0.8;}
		{~c00 >= 187.5}
		{~bufferSynth.set(\attack0, 0.75); ~bufferSynth.set(\release0, 0.75); ~thresholdOut0 = 0.9;}
		{~c00 >= 125}
		{~bufferSynth.set(\attack0, 1); ~bufferSynth.set(\release0, 1); ~thresholdOut0 = 1;}
		{~c00 <= 62.5}
		{~bufferSynth.set(\attack0, 1.5); ~bufferSynth.set(\release0, 1.5); ~thresholdOut0 = 1;};
		c0 = 0;
		~e00 = ~e00 - e0;
		~e00 = e0;
		case
		{~e00 >= 750}
		{~bufferSynth.set(\attack1, 0.01); ~bufferSynth.set(\release1, 0.01); ~thresholdOut1 = 0;}
		{~e00 >= 687.5}
		{~bufferSynth.set(\attack1, 0.025); ~bufferSynth.set(\release1, 0.025); ~thresholdOut1 = 0.1;}
		{~e00 >= 625}
		{~bufferSynth.set(\attack1, 0.05); ~bufferSynth.set(\release1, 0.05); ~thresholdOut1 = 0.2;}
		{~e00 >= 562.5}
		{~bufferSynth.set(\attack1, 0.075); ~bufferSynth.set(\release1, 0.075); ~thresholdOut1 = 0.3;}
		{~e00 >= 500}
		{~bufferSynth.set(\attack1, 0.1); ~bufferSynth.set(\release1, 0.1); ~thresholdOut1 = 0.4;}
		{~e00 >= 437.5}
		{~bufferSynth.set(\attack1, 0.25); ~bufferSynth.set(\release1, 0.25); ~thresholdOut1 = 0.5;}
		{~e00 >= 375}
		{~bufferSynth.set(\attack1, 0.3); ~bufferSynth.set(\release1, 0.3); ~thresholdOut1 = 0.6;}
		{~e00 >= 312.5}
		{~bufferSynth.set(\attack1, 0.4); ~bufferSynth.set(\release1, 0.4); ~thresholdOut1 = 0.7;}
		{~e00 >= 250}
		{~bufferSynth.set(\attack1, 0.5); ~bufferSynth.set(\release1, 0.5); ~thresholdOut1 = 0.8;}
		{~e00 >= 187.5}
		{~bufferSynth.set(\attack1, 0.75); ~bufferSynth.set(\release1, 0.75); ~thresholdOut1 = 0.9;}
		{~e00 >= 125}
		{~bufferSynth.set(\attack1, 1); ~bufferSynth.set(\release1, 1); ~thresholdOut1 = 1;}
		{~e00 <= 62.5}
		{~bufferSynth.set(\attack1, 1.5); ~bufferSynth.set(\release1, 1.5); ~thresholdOut1 = 1;};
		e0 = 0;
		~g00 = ~g00 - g0;
		~g00 = g0;
		case
		{~g00 >= 750}
		{~bufferSynth.set(\attack2, 0.01); ~bufferSynth.set(\release2, 0.01);}
		{~g00 >= 687.5}
		{~bufferSynth.set(\attack2, 0.025); ~bufferSynth.set(\release2, 0.025);}
		{~g00 >= 625}
		{~bufferSynth.set(\attack2, 0.05); ~bufferSynth.set(\release2, 0.05);}
		{~g00 >= 562.5}
		{~bufferSynth.set(\attack2, 0.075); ~bufferSynth.set(\release2, 0.075);}
		{~g00 >= 500}
		{~bufferSynth.set(\attack2, 0.1); ~bufferSynth.set(\release2, 0.1);}
		{~g00 >= 437.5}
		{~bufferSynth.set(\attack2, 0.25); ~bufferSynth.set(\release2, 0.25);}
		{~g00 >= 375}
		{~bufferSynth.set(\attack2, 0.3); ~bufferSynth.set(\release2, 0.3);}
		{~g00 >= 312.5}
		{~bufferSynth.set(\attack2, 0.4); ~bufferSynth.set(\release2, 0.4);}
		{~g00 >= 250}
		{~bufferSynth.set(\attack2, 0.5); ~bufferSynth.set(\release2, 0.5);}
		{~g00 >= 187.5}
		{~bufferSynth.set(\attack2, 0.75); ~bufferSynth.set(\release2, 0.75);}
		{~g00 >= 125}
		{~bufferSynth.set(\attack2, 1); ~bufferSynth.set(\release2, 1);}
		{~g00 <= 62.5}
		{~bufferSynth.set(\attack2, 1.5); ~bufferSynth.set(\release2, 1.5);};
		g0 = 0;
		1.wait;
		});
		});

// random search process for audio fx
	~algoTime = 0.5;

	~autoFXButton0 = Button(~w5, Rect(100, 25, 100, 25));
	~autoFXButton0.font_(Font("Monaco", 10));
	~autoFXButton0.states_([
					["Auto FX Off",Color.white,Color.gray],
					["Auto FX On",Color.gray,Color.white],
							]);

	~autoFXButton0.action_({arg butt;
	if ( butt.value == 1,
	{
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Auto FX On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		~generativeRoutine = Routine.new({
	inf.do({ arg i;

         var offset, duration, cutlength, barposition, stretch, roomSize, damper, volume, filterFreq0, filterRes0, filterFreq1, filterRes1, grainsize0, grainsize1, grainpan0, grainpan1, grainvol0, grainvol1, reverbTime, revSpread, earlyRef, tailLev, quantize;

         stretch = (-2..2).choose;
         roomSize = (10..300).choose;
         damper = (0..1).choose;
         filterFreq0 = (40..20000).choose;
         filterRes0 = (0.01..1).choose;
         filterFreq1 = (40..440).choose;
         filterRes1 = (0.01..1).choose;
         grainsize0 = (0.05..0.15).choose;
         grainsize1 = (0.05..0.15).choose;
         grainpan0 = (-1..1).choose;
         grainpan1 = (-1..1).choose;
         grainvol0 = (0.25..1).choose;
         grainvol1 = (0.25..1).choose;
         offset = ((~start)..(~length)).choose;
         cutlength = (0.01..1).choose;
         reverbTime = (0.1..5).choose;
         revSpread = (10..100).choose;
         earlyRef = (0.5..1).choose;
         tailLev = (0.5..1).choose;
         quantize = [1,2,4,8,12, 16].choose;

		 ~bufferSynth.set(\spliceDuration, cutlength.round(quantize));
         ~bufferSynth.set(\reset2, offset.round(~sampleFile2.numFrames/(quantize)));
//		 ~bufferSynth.set(\spliceDuration, cutlength);
//         ~bufferSynth.set(\reset2, offset);
         ~bufferSynth.set(\stretcher, stretch);
         ~fxSynth.set(\roomSize0, roomSize);
         ~fxSynth.set(\damper, damper);
         ~fxSynth.set(\lpfFreq, filterFreq0);
         ~fxSynth.set(\lpfRes, filterRes0);
         ~fxSynth.set(\hpfFreq, filterFreq1);
         ~fxSynth.set(\hpfRes, filterRes1);
         ~fxSynth.set(\grainSize0, grainsize0);
         ~fxSynth.set(\grainSize1, grainsize1);
         ~fxSynth.set(\grainPan0, grainpan0);
         ~fxSynth.set(\grainPan1, grainpan1);
         ~fxSynth.set(\grainVol0, grainvol0);
         ~fxSynth.set(\grainVol1, grainvol1);
         ~fxSynth.set(\revTime1, reverbTime);
         ~fxSynth.set(\spread, revSpread);
         ~fxSynth.set(\earlyRf, earlyRef);
         ~fxSynth.set(\tailLev, tailLev);

 		~algoTime.wait;
		});
		});
		~generativeRoutine.reset;
		~generativeRoutine.play;
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~autoFXButton0.valueAction = " ++ ~autoFXButton0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
		},
	{
	~generativeRoutine.stop;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Auto FX Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~autoFXButton0.valueAction = " ++ ~autoFXButton0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);	}
	)
	});

// set update speed of random search process for audio FX
	~autoSpeedButton0 = NumberBox(~w5, Rect(100, 50, 100, 25));
	~autoSpeedButton0.font_(Font("Monaco", 10));
	~autoSpeedButton0.clipLo = 0.1;
	~autoSpeedButton0.value = 0.5;
	~autoSpeedButton0.action_({arg numb;
		~autoFXButton0.valueAction = 0;
		~algoTime = numb.value;
		~autoFXButton0.valueAction = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Algorithm Changing Every "  ++  numb.value.asString ++ " seconds", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~autoSpeedButton0.valueAction = " ++ numb.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	});

// toggle auto buffer reset position of slave
	~resetSlicer0 = Button(~w5, Rect(100, 0, 100, 25));
	~resetSlicer0.font_(Font("Monaco", 10));
	~resetSlicer0.states_([
					["Slicer Off",Color.white,Color.gray],
					["Slicer On",Color.gray,Color.white],
							]);

	~resetSlicer0.action_({arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\resetChooser0, 0);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Slicer Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~resetSlicer0.valueAction = " ++ ~resetSlicer0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);	},
	{~bufferSynth.set(\resetChooser0, 1);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Slicer On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~resetSlicer0.valueAction = " ++ ~resetSlicer0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);	}
	)
	});

// toggle auto time stretch	of slave
	~stretchSlicer0 = Button(~w5, Rect(200, 0, 100, 25));
	~stretchSlicer0.font_(Font("Monaco", 10));
	~stretchSlicer0.states_([
					["Stretcher Off",Color.white,Color.gray],
					["Stretcher On",Color.gray,Color.white],
							]);

	~stretchSlicer0.action_({arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\stretchChooser0, 0);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Stretcher Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~stretchSlicer0.valueAction = " ++ ~stretchSlicer0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);		},
	{~bufferSynth.set(\stretchChooser0, 1);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Stretcher On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~stretchSlicer0.valueAction = " ++ ~stretchSlicer0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);		}
	)
	});

// toggle auto filter of output mix
	~filterSlicer0 = Button(~w5, Rect(200, 25, 100, 25));
	~filterSlicer0.font_(Font("Monaco", 10));
	~filterSlicer0.states_([
					["Auto Filter Off",Color.white,Color.gray],
					["Auto Filter On",Color.gray,Color.white],
							]);

	~filterSlicer0.action_({arg butt;
	if ( butt.value == 0,
	{~fxSynth.set(\outputChooser, 0);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Auto Filter Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~filterSlicer0.valueAction = " ++ ~filterSlicer0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);			},
	{~fxSynth.set(\outputChooser, 1);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Auto Filter On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~filterSlicer0.valueAction = " ++ ~filterSlicer0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);			}
	)
	});

// default network sender addresses
~networkSender0 = NetAddr("169.0.0.2", 57120);
~networkSender1 = NetAddr("169.0.0.3", 57120);
~networkSender2 = NetAddr("169.0.0.4", 57120);
~networkSender3 = NetAddr("169.0.0.5", 57120);
~networkSender4 = NetAddr("169.0.0.6", 57120);
~networkSender5 = NetAddr("169.0.0.2", 57120);
~networkSender6 = NetAddr("169.0.0.3", 57120);
~networkSender7 = NetAddr("169.0.0.4", 57120);
~networkReturn0 = NetAddr("169.0.0.4", 57120);

// default network receiver addresses
~networkReceiver0 = NetAddr("169.0.0.1", 57120);

// textfields for IP addresses
	~receiverText = StaticText(~w5, Rect(15, 135, 75, 15));
	~receiverText.string = "FROM";
	~receiverText.font = Font("Monaco", 14);
	~receiverText.stringColor_(Color.red);

	~receiverButton = Button(~w5, Rect(50, 135, 40, 15));
	~receiverButton.states_([
					["",Color.white,Color.red],
					["",Color.white,Color.green],
							]);

	~receiverButton1 = Button(~w5, Rect(50, 0, 40/8, 15));
	~receiverButton1.states_([
					["",Color.white,Color.red],
					["",Color.white,Color.green],
							]);

	~receiverButton2 = Button(~w5, Rect(50 + 5, 0, 40/8, 15));
	~receiverButton2.states_([
					["",Color.white,Color.red],
					["",Color.white,Color.green],
							]);

	~receiverButton3 = Button(~w5, Rect(50 + 10, 0, 40/8, 15));
	~receiverButton3.states_([
					["",Color.white,Color.red],
					["",Color.white,Color.green],
							]);

	~receiverButton4 = Button(~w5, Rect(50 + 15, 0, 40/8, 15));
	~receiverButton4.states_([
					["",Color.white,Color.red],
					["",Color.white,Color.green],
							]);

	~receiverButton5 = Button(~w5, Rect(50 + 20, 0, 40/8, 15));
	~receiverButton5.states_([
					["",Color.white,Color.red],
					["",Color.white,Color.green],
							]);

	~receiverButton6 = Button(~w5, Rect(50 + 25, 0, 40/8, 15));
	~receiverButton6.states_([
					["",Color.white,Color.red],
					["",Color.white,Color.green],
							]);

	~receiverButton7 = Button(~w5, Rect(50 + 30, 0, 40/8, 15));
	~receiverButton7.states_([
					["",Color.white,Color.red],
					["",Color.white,Color.green],
							]);

	~receiverButton8 = Button(~w5, Rect(50 + 35, 0, 40/8, 15));
	~receiverButton8.states_([
					["",Color.white,Color.red],
					["",Color.white,Color.green],
							]);
// toggle netowrk receive
	~networkSelectOn0 = Button(~w5, Rect(15, 167.5, 75, 25));
	~networkSelectOn0 .font_(Font("Monaco", 10));
	~networkSelectOn0.states_([
					["Receive Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Receive On",Color.white.alpha_(0.8),Color.green.alpha_(0.8)],
							]);

// if network off, use local data
	~networkSelectOn0.action_({arg butt;
	if ( butt.value == 0,
	{
		~networkSelector0 = 0; ~bufferSynth.set(\networkChooser0, 0);

		~triggerResponder0.remove;
		~triggerResponder1.remove;
		~triggerResponder2.remove;
		~filterResponder0.remove;
		~filterResponder1.remove;
		~filterResponder2.remove;
		~mfccDataResponder0.remove;
		~mfccDataResponder1.remove;
		~mfccDataResponder2.remove;
		~pitchResponder0.remove;
		~clockResponder0.remove;
		~systemResponder0.remove;
		~networkUpdate0.stop;
		~networkUpdate0.reset;
		~attackText0[23].stringColor_(Color.yellow);
		~attackText0[24].stringColor_(Color.blue);
		~onText0.stringColor_(Color.red);
		~networkText0.remove;
		~networkText1.remove;
		~networkText2.remove;
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Receive Off "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));	~textEditor.selectLine(~textEditor.string.size);						~textEditor.selectLine(~textEditor.string.size);
		},

// if network on, use network data
	{~networkSelector0 = 1; ~bufferSynth.set(\networkChooser0, 1);

		~triggerResponder0.remove;
		~triggerResponder1.remove;
		~triggerResponder2.remove;
		~filterResponder0.remove;
		~filterResponder1.remove;
		~filterResponder2.remove;
		~mfccDataResponder0.remove;
		~mfccDataResponder1.remove;
		~mfccDataResponder2.remove;
		~pitchResponder0.remove;
		~clockResponder0.remove;
		~systemResponder0.remove;

		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Receive On "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));	~textEditor.selectLine(~textEditor.string.size);							~textEditor.selectLine(~textEditor.string.size);

// receive triggers of networked control one
	~triggerResponder0 = OSCresponder(~networkReceiver0, '/triggers0', {| t, r, msg|
	{
	~trigger0Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive triggers of networked control two
	~triggerResponder1 = OSCresponder(~networkReceiver0, '/triggers1', {| t, r, msg|
	{
	~trigger1Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive triggers of networked control three/slave
	~triggerResponder2 = OSCresponder(~networkReceiver0, '/triggers2', {| t, r, msg|
	{
	~grainTriggerReply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive spectral following of networked control one
	~filterResponder0 = OSCresponder(~networkReceiver0, '/filters0', {| t, r, msg|
	{
	~filter0Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive spectral following of networked control two
	~filterResponder1 = OSCresponder(~networkReceiver0, '/filters1', {| t, r, msg|
	{
	~filter1Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive spectral following of networked control three/slave
	~filterResponder2 = OSCresponder(~networkReceiver0, '/filters2', {| t, r, msg|
	{
	~filter2Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive MFCC of networked control one
	~mfccDataResponder0 = OSCresponder(~networkReceiver0, '/mfccData0', {| t, r, msg|
	{
	~mfccData0Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13], msg[14]];
	}.defer;
	}).add;

// receive MFCC of networked control two
	~mfccDataResponder1 = OSCresponder(~networkReceiver0, '/mfccData1', {| t, r, msg|
	{
	~mfccData1Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13], msg[14]];
	}.defer;
	}).add;

// receive MFCC of networked control three/slave
	~mfccDataResponder2 = OSCresponder(~networkReceiver0, '/mfccData2', {| t, r, msg|
	{
	~mfccData2Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive pitch of networked control one
	~pitchResponder0 = OSCresponder(~networkReceiver0, '/pitch0', {| t, r, msg|
	{
	~pitchReply0 = [msg[1], msg[2], msg[3]];
	}.defer;
	}).add;

// receive clock of networked instance
	~clockResponder0 = OSCresponder(~networkReceiver0, '/clock0', {| t, r, msg|
	{
	~clockReply0 = [msg[1], msg[2], msg[3]];
	}.defer;
	}).add;

// receive selected variables of networked instance
	~systemResponder0 = OSCresponder(~networkReceiver0, '/system0', {| t, r, msg|
	{
	~systemReply0 = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11]];
	}.defer;
	}).add;

// set networked values in local instance
	~networkUpdate0 = Task({
	loop{
		(1/60).wait;

		~granularMacroSynth0.set(\networkOnsets0, ~trigger0Reply);
		~granularMacroSynth1.set(\networkOnsets1, ~trigger1Reply);
		~granularMacroSynth2.set(\networkOnsets2, ~grainTriggerReply);

		~envelopeSynth.set(\networkOnsets0, ~trigger0Reply);
		~envelopeSynth.set(\networkOnsets1, ~trigger1Reply);
		~envelopeSynth.set(\networkOnsets2, ~grainTriggerReply);

		~bufferSynth.set(\networkOnsets0, ~trigger0Reply);
		~bufferSynth.set(\networkOnsets1, ~trigger1Reply);
		~bufferSynth.set(\networkOnsets2, ~grainTriggerReply);

		~analysisSynth.set(\networkFilters0, ~filter0Reply);
		~analysisSynth.set(\networkFilters1, ~filter1Reply);
		~analysisSynth.set(\networkFilters2, ~filter2Reply);

		~granularMacroSynth0.set(\networkFilters0, ~filter0Reply);
		~granularMacroSynth1.set(\networkFilters1, ~filter1Reply);
		~granularMacroSynth2.set(\networkFilters2, ~filter2Reply);

		~pan0Synth.set(\networkFilters0, ~filter0Reply);
		~pan1Synth.set(\networkFilters1, ~filter1Reply);
		~pan2Synth.set(\networkFilters2, ~filter2Reply);

		~bufferSynth.set(\networkPitch0, ~pitchReply0);

			};
		}).start;

		~attackText0[24].stringColor_(Color.blue.alpha_(0.0));
		~attackText0[23].stringColor_(Color.yellow.alpha_(0.0));
		~onText0.stringColor_(Color.red.alpha_(0.0));
		~networkText0 = StaticText(~w1, Rect(26, 26, (1920/3)-50, height-100));
		~networkText1 = StaticText(~w1, Rect((640)+25, 26, (1920/3)-50, height-100));
		~networkText2 = StaticText(~w1, Rect(1280+25, 26, (1920/3)-50, height-100));
		~networkText0.string = "network receive on";
		~networkText1.string = "network receive on";
		~networkText2.string = "network receive on";
		~networkText0.stringColor_(Color.gray);
		~networkText0.font_(Font("Monaco", 50));
		~networkText1.stringColor_(Color.gray);
		~networkText1.font_(Font("Monaco", 50));
		~networkText2.stringColor_(Color.gray);
		~networkText2.font_(Font("Monaco", 50));

	}
	)
	});

// network controls and window for senders
	~outWindowCheck0 = 0;
	~inWindowCheck0 = 0;

	~ipOfSender0 = TextField(~w5, Rect(15, 15, 75, 15));
	~ipOfSender0.font_(Font("Monaco", 10));
	~ipOfSender0.string = "Send IP 1";
	~ipOfSender0.action = {arg field;
	~networkSender0 = NetAddr(field.value, 57120);

	~networkResponder0.remove;

	~networkResponder0 = OSCresponder(~networkSender0, '/return0', {| t, r, msg|
	{
	~networkReceived0 = [msg[1]];
	}.defer;
	}).add;

	~outWindowCheck0 = ~outWindowCheck0 +1;

		if( ~outWindowCheck0 == 1,



	{

// create Network Controls Out window
	~w4 = Window("Network Controls Out", Rect(70, 25, 350, 125), false, true, scroll: false);
	~w4.view.background_(Color.gray);
	~w4.userCanClose = false;
	~w4.alwaysOnTop = true;

	~receiverInText = StaticText(~w4, Rect(0, 5, 100, 75));
	~receiverInText.string = "out";
	~receiverInText.align = \center;
	~receiverInText.font = Font("Monaco", 50);
	~receiverInText.stringColor_(Color.black.alpha_(0.5));

// toggle network sync clock
	~networkClockSyncOut = Button(~w4, Rect(0, 75, 100, 25));
	~networkClockSyncOut.font_(Font("Monaco", 8.5));
     ~networkClockSyncOut.states_([["Sync Off", Color.white, Color.black.alpha_(0.8)], ["Sync On", Color.black.alpha_(0.8), Color.white]]);
     ~networkClockSyncOut.action_({arg butt;

	if (butt.value == 0,
	{

	~networkSyncOut0 = 0;

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Clock Sync Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

	});

	if(butt.value == 1,

	{

	~networkSyncOut0 = 1;

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Clock Sync On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

	});

	});

// toggle networked instance's network functionality
	~networkChangeSwitch0 = Button(~w4, Rect(0, 100, 100, 25));
	~networkChangeSwitch0.font_(Font("Monaco", 10));
	~networkChangeSwitch0.states_([
					["Network Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Network On", Color.green.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSwitch0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSwitchOut0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSwitchOut0 = 1;
	~textEditor.stringColor_(Color.green, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control one sample ugens on networked instances
	~networkChangeSample0 = Button(~w4, Rect(100, 0, 125, 25));
	~networkChangeSample0.font_(Font("Monaco", 10));
	~networkChangeSample0.states_([
					["Sample Change Off", Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["Sample Change On", Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);

	~networkChangeSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 1;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control two sample ugens on networked instances
	~networkChangeSample1 = Button(~w4, Rect(100, 25, 125, 25));
	~networkChangeSample1.font_(Font("Monaco", 10));
	~networkChangeSample1.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Sample Change On",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample1.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 2;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control three/slave sample ugens on networked instances
	~networkChangeSample2 = Button(~w4, Rect(100, 50, 125, 25));
	~networkChangeSample2.font_(Font("Monaco", 10));
	~networkChangeSample2.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["Sample Change On",Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample2.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 3;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// select sample from selected database on networked instance
	~networkChangeSelector0 = PopUpMenu(~w4, Rect(100, 75, 125, 25));
	~networkChangeSelector0.items = ["None","C Major Scale", "Don't You Want Me Baby", "Crockett Stereo"];
	~networkChangeSelector0.background_(Color.gray.alpha_(0.8));
	~networkChangeSelector0.font_(Font("Monaco", 10));
	~networkChangeSelector0.action = {arg menu;
			~networkSampleSelector0 = (menu.value)-1;

	};

// trigger live sampling on networked instance
	~networkRecordSample0 = Button(~w4, Rect(225, 0, 125, 25));
	~networkRecordSample0.font_(Font("Monaco", 10));
	~networkRecordSample0.states_([
					["Record Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Record On", Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkRecordSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkRecord0 = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkRecord0 = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Recording... ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// set length of live sample on networked instance
	~recordNetworkLengthInput0 = TextField(~w4, Rect(225, 25, 125, 25));
	~recordNetworkLengthInput0.font_(Font("Monaco", 10));
	~recordNetworkLengthInput0.string = "1.0";
	~recordNetworkLengthInput0.stringColor = Color.white.alpha_(0.8);
	~recordNetworkLengthInput0.background = Color.red.alpha_(0.8);
	~recordNetworkLengthInput0.action = {arg field;
		~recordNetworkLength0 = field.value.asInteger.max(1);
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Length = "  ++  field.value.asString ++ " seconds", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);
	};

// set destination of live sample recording on networked instance
	~quickNetworkLoadSelector0 = PopUpMenu(~w4, Rect(225, 50, 125, 25));
	~quickNetworkLoadSelector0.font_(Font("Monaco", 10));
	~quickNetworkLoadSelector0.items = ["to Yellow", "to Red", "to Blue"];
	~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
	~quickNetworkLoadSelector0.action = {arg menu;
		if (menu.value == 0,
		{

		~quickLoadNetworkValue = 0;

		~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.black.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Yellow ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 1,
		{

		~quickLoadNetworkValue = 1;

		~quickNetworkLoadSelector0.background = Color.red.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Red ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 2,
		{

		~quickLoadNetworkValue = 2;

		~quickNetworkLoadSelector0.background = Color.blue.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Blue ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);
	};

// load live sample to relative destination on networked instance
	~quickNetworkLoad0 = Button(~w4, Rect(225, 75, 125, 25));
	~quickNetworkLoad0.font_(Font("Monaco", 10));
	~quickNetworkLoad0.states_([
					["Quick Load Off",Color.black,Color.white],
					["Quick Load On",Color.white,Color.black],
							]);

	~quickNetworkLoad0.action_({arg butt;
	if ( (butt.value == 0),
	{~quickLoadNetworkOn = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~quickLoadNetworkOn = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle input for control one on networked instance
	~networkInputSwitch0 = PopUpMenu(~w4, Rect(100, 100, 250/3, 25));
	~networkInputSwitch0.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch0.font_(Font("Monaco", 10));
	~networkInputSwitch0.background = Color.yellow.alpha_(0.8);

	~networkInputSwitch0.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector0 = 0;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector0 = 1;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector0 = 2;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control two on networked instance
	~networkInputSwitch1 = PopUpMenu(~w4, Rect(100 + (250/3), 100, 250/3, 25));
	~networkInputSwitch1.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch1.font_(Font("Monaco", 10));
	~networkInputSwitch1.background = Color.red.alpha_(0.8);
	~networkInputSwitch1.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch1.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector1 = 0;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector1 = 1;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector1 = 2;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control three/slave on networked instance
	~networkInputSwitch2 = PopUpMenu(~w4, Rect(100 + ((250/3) * 2), 100, 250/3, 25));
	~networkInputSwitch2.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch2.font_(Font("Monaco", 10));
	~networkInputSwitch2.background = Color.blue.alpha_(0.8);
	~networkInputSwitch2.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch2.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector2 = 0;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector2 = 1;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector2 = 2;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

	~w4.front;
	};);

		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sending to "  ++  field.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.selectLine(~textEditor.string.size);
	};

	~ipOfSender1 = TextField(~w5, Rect(15, 30, 75, 15));
	~ipOfSender1.font_(Font("Monaco", 10));
	~ipOfSender1.string = "Send IP 2";
	~ipOfSender1.action = {arg field;
		~networkSender1 = NetAddr(field.value, 57120);
		~outWindowCheck0 = ~outWindowCheck0 +1;

	~networkResponder1.remove;

	~networkResponder1 = OSCresponder(~networkSender1, '/return0', {| t, r, msg|
	{
	~networkReceived1 = [msg[1]];
	}.defer;
	}).add;

		if( ~outWindowCheck0 == 1,

	{

	~w4 = Window("Network Controls Out", Rect(70, 25, 350, 125), false, true, scroll: false);
	~w4.view.background_(Color.gray);
	~w4.userCanClose = false;
	~w4.alwaysOnTop = true;

	~receiverInText = StaticText(~w4, Rect(0, 5, 100, 75));
	~receiverInText.string = "out";
	~receiverInText.align = \center;
	~receiverInText.font = Font("Monaco", 50);
	~receiverInText.stringColor_(Color.black.alpha_(0.5));

// toggle network sync clock
	~networkClockSyncOut = Button(~w4, Rect(0, 75, 100, 25));
	~networkClockSyncOut.font_(Font("Monaco", 8.5));
     ~networkClockSyncOut.states_([["Sync Off", Color.white, Color.black.alpha_(0.8)], ["Sync On", Color.black.alpha_(0.8), Color.white]]);
     ~networkClockSyncOut.action_({arg butt;

	if (butt.value == 0,
	{

	~networkSyncOut0 = 0;

	});

	if(butt.value == 1,

	{

	~networkSyncOut0 = 1;

	});

	});

// toggle networked instance's network functionality
	~networkChangeSwitch0 = Button(~w4, Rect(0, 100, 100, 25));
	~networkChangeSwitch0.font_(Font("Monaco", 10));
	~networkChangeSwitch0.states_([
					["Network Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Network On", Color.green.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSwitch0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSwitchOut0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSwitchOut0 = 1;
	~textEditor.stringColor_(Color.green, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control one sample ugens on networked instances
	~networkChangeSample0 = Button(~w4, Rect(100, 0, 125, 25));
	~networkChangeSample0.font_(Font("Monaco", 10));
	~networkChangeSample0.states_([
					["Sample Change Off", Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["Sample Change On", Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);

	~networkChangeSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 1;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control two sample ugens on networked instances
	~networkChangeSample1 = Button(~w4, Rect(100, 25, 125, 25));
	~networkChangeSample1.font_(Font("Monaco", 10));
	~networkChangeSample1.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Sample Change On",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample1.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 2;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control three/slave sample ugens on networked instances
	~networkChangeSample2 = Button(~w4, Rect(100, 50, 125, 25));
	~networkChangeSample2.font_(Font("Monaco", 10));
	~networkChangeSample2.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["Sample Change On",Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample2.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 3;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// select sample from selected database on networked instance

	~networkChangeSelector0 = PopUpMenu(~w4, Rect(100, 75, 125, 25));
	~networkChangeSelector0.items = ["None","C Major Scale", "Don't You Want Me Baby", "Crockett Stereo"];
	~networkChangeSelector0.background_(Color.gray.alpha_(0.8));
	~networkChangeSelector0.font_(Font("Monaco", 10));
	~networkChangeSelector0.action = {arg menu;
			~networkSampleSelector0 = (menu.value)-1;

	};

// trigger live sampling on networked instance
	~networkRecordSample0 = Button(~w4, Rect(225, 0, 125, 25));
	~networkRecordSample0.font_(Font("Monaco", 10));
	~networkRecordSample0.states_([
					["Record Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Record On", Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkRecordSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkRecord0 = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkRecord0 = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Recording... ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// set length of live sample on networked instance
	~recordNetworkLengthInput0 = TextField(~w4, Rect(225, 25, 125, 25));
	~recordNetworkLengthInput0.font_(Font("Monaco", 10));
	~recordNetworkLengthInput0.string = "1.0";
	~recordNetworkLengthInput0.stringColor = Color.white.alpha_(0.8);
	~recordNetworkLengthInput0.background = Color.red.alpha_(0.8);
	~recordNetworkLengthInput0.action = {arg field;
		~recordNetworkLength0 = field.value.asInteger.max(1);
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Length = "  ++  field.value.asString ++ " seconds", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);
	};

// set destination of live sample recording on networked instance
	~quickNetworkLoadSelector0 = PopUpMenu(~w4, Rect(225, 50, 125, 25));
	~quickNetworkLoadSelector0.font_(Font("Monaco", 10));
	~quickNetworkLoadSelector0.items = ["to Yellow", "to Red", "to Blue"];
	~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
	~quickNetworkLoadSelector0.action = {arg menu;
		if (menu.value == 0,
		{

		~quickLoadNetworkValue = 0;

		~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.black.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Yellow ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 1,
		{

		~quickLoadNetworkValue = 1;

		~quickNetworkLoadSelector0.background = Color.red.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Red ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 2,
		{

		~quickLoadNetworkValue = 2;

		~quickNetworkLoadSelector0.background = Color.blue.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Blue ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);
	};

// load live sample to relative destination on networked instance
	~quickNetworkLoad0 = Button(~w4, Rect(225, 75, 125, 25));
	~quickNetworkLoad0.font_(Font("Monaco", 10));
	~quickNetworkLoad0.states_([
					["Quick Load Off",Color.black,Color.white],
					["Quick Load On",Color.white,Color.black],
							]);

	~quickNetworkLoad0.action_({arg butt;
	if ( (butt.value == 0),
	{~quickLoadNetworkOn = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~quickLoadNetworkOn = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle input for control one on networked instance
	~networkInputSwitch0 = PopUpMenu(~w4, Rect(100, 100, 250/3, 25));
	~networkInputSwitch0.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch0.font_(Font("Monaco", 10));
	~networkInputSwitch0.background = Color.yellow.alpha_(0.8);

	~networkInputSwitch0.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector0 = 0;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector0 = 1;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector0 = 2;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control two on networked instance
	~networkInputSwitch1 = PopUpMenu(~w4, Rect(100 + (250/3), 100, 250/3, 25));
	~networkInputSwitch1.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch1.font_(Font("Monaco", 10));
	~networkInputSwitch1.background = Color.red.alpha_(0.8);
	~networkInputSwitch1.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch1.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector1 = 0;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector1 = 1;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector1 = 2;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control three/slave on networked instance
	~networkInputSwitch2 = PopUpMenu(~w4, Rect(100 + ((250/3) * 2), 100, 250/3, 25));
	~networkInputSwitch2.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch2.font_(Font("Monaco", 10));
	~networkInputSwitch2.background = Color.blue.alpha_(0.8);
	~networkInputSwitch2.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch2.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector2 = 0;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector2 = 1;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector2 = 2;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

	~w4.front;
	};);

		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sending to "  ++  field.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));	~textEditor.selectLine(~textEditor.string.size);			~textEditor.selectLine(~textEditor.string.size);
	};

	~ipOfSender2 = TextField(~w5, Rect(15, 45, 75, 15));
	~ipOfSender2.font_(Font("Monaco", 10));
	~ipOfSender2.string = "Send IP 3";
	~ipOfSender2.action = {arg field;
		~networkSender2 = NetAddr(field.value, 57120);

	~networkResponder2.remove;

	~networkResponder2 = OSCresponder(~networkSender2, '/return0', {| t, r, msg|
	{
	~networkReceived2 = [msg[1]];
	}.defer;
	}).add;

		~outWindowCheck0 = ~outWindowCheck0 +1;

		if( ~outWindowCheck0 == 1,

	{

	~w4 = Window("Network Controls Out", Rect(70, 25, 350, 125), false, true, scroll: false);
	~w4.view.background_(Color.gray);
	~w4.userCanClose = false;
	~w4.alwaysOnTop = true;

	~receiverInText = StaticText(~w4, Rect(0, 5, 100, 75));
	~receiverInText.string = "out";
	~receiverInText.align = \center;
	~receiverInText.font = Font("Monaco", 50);
	~receiverInText.stringColor_(Color.black.alpha_(0.5));

// toggle network sync clock
	~networkClockSyncOut = Button(~w4, Rect(0, 75, 100, 25));
	~networkClockSyncOut.font_(Font("Monaco", 8.5));
     ~networkClockSyncOut.states_([["Sync Off", Color.white, Color.black.alpha_(0.8)], ["Sync On", Color.black.alpha_(0.8), Color.white]]);
     ~networkClockSyncOut.action_({arg butt;

	if (butt.value == 0,
	{

	~networkSyncOut0 = 0;

	});

	if(butt.value == 1,

	{

	~networkSyncOut0 = 1;

	});

	});

// toggle networked instance's network functionality
	~networkChangeSwitch0 = Button(~w4, Rect(0, 100, 100, 25));
	~networkChangeSwitch0.font_(Font("Monaco", 10));
	~networkChangeSwitch0.states_([
					["Network Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Network On", Color.green.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSwitch0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSwitchOut0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSwitchOut0 = 1;
	~textEditor.stringColor_(Color.green, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control one sample ugens on networked instances
	~networkChangeSample0 = Button(~w4, Rect(100, 0, 125, 25));
	~networkChangeSample0.font_(Font("Monaco", 10));
	~networkChangeSample0.states_([
					["Sample Change Off", Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["Sample Change On", Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);

	~networkChangeSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 1;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control two sample ugens on networked instances
	~networkChangeSample1 = Button(~w4, Rect(100, 25, 125, 25));
	~networkChangeSample1.font_(Font("Monaco", 10));
	~networkChangeSample1.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Sample Change On",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample1.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 2;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control three/slave sample ugens on networked instances
	~networkChangeSample2 = Button(~w4, Rect(100, 50, 125, 25));
	~networkChangeSample2.font_(Font("Monaco", 10));
	~networkChangeSample2.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["Sample Change On",Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample2.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 3;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// select sample from selected database on networked instance
	~networkChangeSelector0 = PopUpMenu(~w4, Rect(100, 75, 125, 25));
	~networkChangeSelector0.items = ["None","C Major Scale", "Don't You Want Me Baby", "Crockett Stereo"];
	~networkChangeSelector0.background_(Color.gray.alpha_(0.8));
	~networkChangeSelector0.font_(Font("Monaco", 10));
	~networkChangeSelector0.action = {arg menu;
			~networkSampleSelector0 = (menu.value)-1;

	};

// trigger live sampling on networked instance
	~networkRecordSample0 = Button(~w4, Rect(225, 0, 125, 25));
	~networkRecordSample0.font_(Font("Monaco", 10));
	~networkRecordSample0.states_([
					["Record Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Record On", Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkRecordSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkRecord0 = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkRecord0 = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Recording... ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// set length of live sample on networked instance
	~recordNetworkLengthInput0 = TextField(~w4, Rect(225, 25, 125, 25));
	~recordNetworkLengthInput0.font_(Font("Monaco", 10));
	~recordNetworkLengthInput0.string = "1.0";
	~recordNetworkLengthInput0.stringColor = Color.white.alpha_(0.8);
	~recordNetworkLengthInput0.background = Color.red.alpha_(0.8);
	~recordNetworkLengthInput0.action = {arg field;
		~recordNetworkLength0 = field.value.asInteger.max(1);
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Length = "  ++  field.value.asString ++ " seconds", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);
	};

// set destination of live sample recording on networked instance
	~quickNetworkLoadSelector0 = PopUpMenu(~w4, Rect(225, 50, 125, 25));
	~quickNetworkLoadSelector0.font_(Font("Monaco", 10));
	~quickNetworkLoadSelector0.items = ["to Yellow", "to Red", "to Blue"];
	~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
	~quickNetworkLoadSelector0.action = {arg menu;
		if (menu.value == 0,
		{

		~quickLoadNetworkValue = 0;

		~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.black.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Yellow ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 1,
		{

		~quickLoadNetworkValue = 1;

		~quickNetworkLoadSelector0.background = Color.red.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Red ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 2,
		{

		~quickLoadNetworkValue = 2;

		~quickNetworkLoadSelector0.background = Color.blue.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Blue ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);
	};

// load live sample to relative destination on networked instance
	~quickNetworkLoad0 = Button(~w4, Rect(225, 75, 125, 25));
	~quickNetworkLoad0.font_(Font("Monaco", 10));
	~quickNetworkLoad0.states_([
					["Quick Load Off",Color.black,Color.white],
					["Quick Load On",Color.white,Color.black],
							]);

	~quickNetworkLoad0.action_({arg butt;
	if ( (butt.value == 0),
	{~quickLoadNetworkOn = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~quickLoadNetworkOn = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle input for control one on networked instance
	~networkInputSwitch0 = PopUpMenu(~w4, Rect(100, 100, 250/3, 25));
	~networkInputSwitch0.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch0.font_(Font("Monaco", 10));
	~networkInputSwitch0.background = Color.yellow.alpha_(0.8);

	~networkInputSwitch0.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector0 = 0;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector0 = 1;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector0 = 2;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control two on networked instance
	~networkInputSwitch1 = PopUpMenu(~w4, Rect(100 + (250/3), 100, 250/3, 25));
	~networkInputSwitch1.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch1.font_(Font("Monaco", 10));
	~networkInputSwitch1.background = Color.red.alpha_(0.8);
	~networkInputSwitch1.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch1.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector1 = 0;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector1 = 1;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector1 = 2;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control three/slave on networked instance
	~networkInputSwitch2 = PopUpMenu(~w4, Rect(100 + ((250/3) * 2), 100, 250/3, 25));
	~networkInputSwitch2.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch2.font_(Font("Monaco", 10));
	~networkInputSwitch2.background = Color.blue.alpha_(0.8);
	~networkInputSwitch2.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch2.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector2 = 0;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector2 = 1;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector2 = 2;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

	~w4.front;
	};);
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sending to "  ++  field.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));	~textEditor.selectLine(~textEditor.string.size);			~textEditor.selectLine(~textEditor.string.size);
	};

	~ipOfSender3 = TextField(~w5, Rect(15, 60, 75, 15));
	~ipOfSender3.font_(Font("Monaco", 10));
	~ipOfSender3.string = "Send IP 4";
	~ipOfSender3.action = {arg field;
		~networkSender3 = NetAddr(field.value, 57120);

	~networkResponder3.remove;

	~networkResponder3 = OSCresponder(~networkSender3, '/return0', {| t, r, msg|
	{
	~networkReceived3 = [msg[1]];
	}.defer;
	}).add;

		~outWindowCheck0 = ~outWindowCheck0 +1;

		if( ~outWindowCheck0 == 1,

	{

	~w4 = Window("Network Controls Out", Rect(70, 25, 350, 125), false, true, scroll: false);
	~w4.view.background_(Color.gray);
	~w4.userCanClose = false;
	~w4.alwaysOnTop = true;

	~receiverInText = StaticText(~w4, Rect(0, 5, 100, 75));
	~receiverInText.string = "out";
	~receiverInText.align = \center;
	~receiverInText.font = Font("Monaco", 50);
	~receiverInText.stringColor_(Color.black.alpha_(0.5));

// toggle network sync clock
	~networkClockSyncOut = Button(~w4, Rect(0, 75, 100, 25));
	~networkClockSyncOut.font_(Font("Monaco", 8.5));
     ~networkClockSyncOut.states_([["Sync Off", Color.white, Color.black.alpha_(0.8)], ["Sync On", Color.black.alpha_(0.8), Color.white]]);
     ~networkClockSyncOut.action_({arg butt;

	if (butt.value == 0,
	{

	~networkSyncOut0 = 0;

	});

	if(butt.value == 1,

	{

	~networkSyncOut0 = 1;

	});

	});

// toggle networked instance's network functionality
	~networkChangeSwitch0 = Button(~w4, Rect(0, 100, 100, 25));
	~networkChangeSwitch0.font_(Font("Monaco", 10));
	~networkChangeSwitch0.states_([
					["Network Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Network On", Color.green.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSwitch0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSwitchOut0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSwitchOut0 = 1;
	~textEditor.stringColor_(Color.green, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control one sample ugens on networked instances
	~networkChangeSample0 = Button(~w4, Rect(100, 0, 125, 25));
	~networkChangeSample0.font_(Font("Monaco", 10));
	~networkChangeSample0.states_([
					["Sample Change Off", Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["Sample Change On", Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);

	~networkChangeSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 1;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control two sample ugens on networked instances
	~networkChangeSample1 = Button(~w4, Rect(100, 25, 125, 25));
	~networkChangeSample1.font_(Font("Monaco", 10));
	~networkChangeSample1.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Sample Change On",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample1.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 2;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control three/slave sample ugens on networked instances
	~networkChangeSample2 = Button(~w4, Rect(100, 50, 125, 25));
	~networkChangeSample2.font_(Font("Monaco", 10));
	~networkChangeSample2.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["Sample Change On",Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample2.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 3;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// select sample from selected database on networked instance
	~networkChangeSelector0 = PopUpMenu(~w4, Rect(100, 75, 125, 25));
	~networkChangeSelector0.items = ["None","C Major Scale", "Don't You Want Me Baby", "Crockett Stereo"];
	~networkChangeSelector0.background_(Color.gray.alpha_(0.8));
	~networkChangeSelector0.font_(Font("Monaco", 10));
	~networkChangeSelector0.action = {arg menu;
			~networkSampleSelector0 = (menu.value)-1;

	};

// trigger live sampling on networked instance
	~networkRecordSample0 = Button(~w4, Rect(225, 0, 125, 25));
	~networkRecordSample0.font_(Font("Monaco", 10));
	~networkRecordSample0.states_([
					["Record Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Record On", Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkRecordSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkRecord0 = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkRecord0 = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Recording... ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// set length of live sample on networked instance
	~recordNetworkLengthInput0 = TextField(~w4, Rect(225, 25, 125, 25));
	~recordNetworkLengthInput0.font_(Font("Monaco", 10));
	~recordNetworkLengthInput0.string = "1.0";
	~recordNetworkLengthInput0.stringColor = Color.white.alpha_(0.8);
	~recordNetworkLengthInput0.background = Color.red.alpha_(0.8);
	~recordNetworkLengthInput0.action = {arg field;
		~recordNetworkLength0 = field.value.asInteger.max(1);
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Length = "  ++  field.value.asString ++ " seconds", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);
	};

// set destination of live sample recording on networked instance
	~quickNetworkLoadSelector0 = PopUpMenu(~w4, Rect(225, 50, 125, 25));
	~quickNetworkLoadSelector0.font_(Font("Monaco", 10));
	~quickNetworkLoadSelector0.items = ["to Yellow", "to Red", "to Blue"];
	~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
	~quickNetworkLoadSelector0.action = {arg menu;
		if (menu.value == 0,
		{

		~quickLoadNetworkValue = 0;

		~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.black.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Yellow ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 1,
		{

		~quickLoadNetworkValue = 1;

		~quickNetworkLoadSelector0.background = Color.red.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Red ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 2,
		{

		~quickLoadNetworkValue = 2;

		~quickNetworkLoadSelector0.background = Color.blue.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Blue ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);
	};

// load live sample to relative destination on networked instance
	~quickNetworkLoad0 = Button(~w4, Rect(225, 75, 125, 25));
	~quickNetworkLoad0.font_(Font("Monaco", 10));
	~quickNetworkLoad0.states_([
					["Quick Load Off",Color.black,Color.white],
					["Quick Load On",Color.white,Color.black],
							]);

	~quickNetworkLoad0.action_({arg butt;
	if ( (butt.value == 0),
	{~quickLoadNetworkOn = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~quickLoadNetworkOn = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle input for control one on networked instance
	~networkInputSwitch0 = PopUpMenu(~w4, Rect(100, 100, 250/3, 25));
	~networkInputSwitch0.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch0.font_(Font("Monaco", 10));
	~networkInputSwitch0.background = Color.yellow.alpha_(0.8);

	~networkInputSwitch0.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector0 = 0;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector0 = 1;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector0 = 2;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control two on networked instance
	~networkInputSwitch1 = PopUpMenu(~w4, Rect(100 + (250/3), 100, 250/3, 25));
	~networkInputSwitch1.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch1.font_(Font("Monaco", 10));
	~networkInputSwitch1.background = Color.red.alpha_(0.8);
	~networkInputSwitch1.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch1.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector1 = 0;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector1 = 1;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector1 = 2;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control three/slave on networked instance
	~networkInputSwitch2 = PopUpMenu(~w4, Rect(100 + ((250/3) * 2), 100, 250/3, 25));
	~networkInputSwitch2.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch2.font_(Font("Monaco", 10));
	~networkInputSwitch2.background = Color.blue.alpha_(0.8);
	~networkInputSwitch2.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch2.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector2 = 0;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector2 = 1;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector2 = 2;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

	~w4.front;
	};);

		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sending to "  ++  field.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));	~textEditor.selectLine(~textEditor.string.size);			~textEditor.selectLine(~textEditor.string.size);
	};

	~ipOfSender4 = TextField(~w5, Rect(15, 75, 75, 15));
	~ipOfSender4.font_(Font("Monaco", 10));
	~ipOfSender4.string = "Send IP 5";
	~ipOfSender4.action = {arg field;
		~networkSender4 = NetAddr(field.value, 57120);

	~networkResponder4.remove;

	~networkResponder4 = OSCresponder(~networkSender4, '/return0', {| t, r, msg|
	{
	~networkReceived4 = [msg[1]];
	}.defer;
	}).add;

		~outWindowCheck0 = ~outWindowCheck0 +1;

		if( ~outWindowCheck0 == 1,

	{

	~w4 = Window("Network Controls Out", Rect(70, 25, 350, 125), false, true, scroll: false);
	~w4.view.background_(Color.gray);
	~w4.userCanClose = false;
	~w4.alwaysOnTop = true;

	~receiverInText = StaticText(~w4, Rect(0, 5, 100, 75));
	~receiverInText.string = "out";
	~receiverInText.align = \center;
	~receiverInText.font = Font("Monaco", 50);
	~receiverInText.stringColor_(Color.black.alpha_(0.5));

// toggle network sync clock
	~networkClockSyncOut = Button(~w4, Rect(0, 75, 100, 25));
	~networkClockSyncOut.font_(Font("Monaco", 8.5));
     ~networkClockSyncOut.states_([["Sync Off", Color.white, Color.black.alpha_(0.8)], ["Sync On", Color.black.alpha_(0.8), Color.white]]);
     ~networkClockSyncOut.action_({arg butt;

	if (butt.value == 0,
	{

	~networkSyncOut0 = 0;

	});

	if(butt.value == 1,

	{

	~networkSyncOut0 = 1;

	});

	});

// toggle networked instance's network functionality
	~networkChangeSwitch0 = Button(~w4, Rect(0, 100, 100, 25));
	~networkChangeSwitch0.font_(Font("Monaco", 10));
	~networkChangeSwitch0.states_([
					["Network Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Network On", Color.green.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSwitch0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSwitchOut0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSwitchOut0 = 1;
	~textEditor.stringColor_(Color.green, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control one sample ugens on networked instances
	~networkChangeSample0 = Button(~w4, Rect(100, 0, 125, 25));
	~networkChangeSample0.font_(Font("Monaco", 10));
	~networkChangeSample0.states_([
					["Sample Change Off", Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["Sample Change On", Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);

	~networkChangeSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 1;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control two sample ugens on networked instances
	~networkChangeSample1 = Button(~w4, Rect(100, 25, 125, 25));
	~networkChangeSample1.font_(Font("Monaco", 10));
	~networkChangeSample1.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Sample Change On",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample1.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 2;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control three/slave sample ugens on networked instances
	~networkChangeSample2 = Button(~w4, Rect(100, 50, 125, 25));
	~networkChangeSample2.font_(Font("Monaco", 10));
	~networkChangeSample2.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["Sample Change On",Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample2.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 3;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// select sample from selected database on networked instance
	~networkChangeSelector0 = PopUpMenu(~w4, Rect(100, 75, 125, 25));
	~networkChangeSelector0.items = ["None","C Major Scale", "Don't You Want Me Baby", "Crockett Stereo"];
	~networkChangeSelector0.background_(Color.gray.alpha_(0.8));
	~networkChangeSelector0.font_(Font("Monaco", 10));
	~networkChangeSelector0.action = {arg menu;
			~networkSampleSelector0 = (menu.value)-1;

	};

// trigger live sampling on networked instance
	~networkRecordSample0 = Button(~w4, Rect(225, 0, 125, 25));
	~networkRecordSample0.font_(Font("Monaco", 10));
	~networkRecordSample0.states_([
					["Record Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Record On", Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkRecordSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkRecord0 = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkRecord0 = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Recording... ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// set length of live sample on networked instance
	~recordNetworkLengthInput0 = TextField(~w4, Rect(225, 25, 125, 25));
	~recordNetworkLengthInput0.font_(Font("Monaco", 10));
	~recordNetworkLengthInput0.string = "1.0";
	~recordNetworkLengthInput0.stringColor = Color.white.alpha_(0.8);
	~recordNetworkLengthInput0.background = Color.red.alpha_(0.8);
	~recordNetworkLengthInput0.action = {arg field;
		~recordNetworkLength0 = field.value.asInteger.max(1);
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Length = "  ++  field.value.asString ++ " seconds", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);
	};

// set destination of live sample recording on networked instance
	~quickNetworkLoadSelector0 = PopUpMenu(~w4, Rect(225, 50, 125, 25));
	~quickNetworkLoadSelector0.font_(Font("Monaco", 10));
	~quickNetworkLoadSelector0.items = ["to Yellow", "to Red", "to Blue"];
	~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
	~quickNetworkLoadSelector0.action = {arg menu;
		if (menu.value == 0,
		{

		~quickLoadNetworkValue = 0;

		~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.black.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Yellow ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 1,
		{

		~quickLoadNetworkValue = 1;

		~quickNetworkLoadSelector0.background = Color.red.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Red ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 2,
		{

		~quickLoadNetworkValue = 2;

		~quickNetworkLoadSelector0.background = Color.blue.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Blue ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);
	};

// load live sample to relative destination on networked instance
	~quickNetworkLoad0 = Button(~w4, Rect(225, 75, 125, 25));
	~quickNetworkLoad0.font_(Font("Monaco", 10));
	~quickNetworkLoad0.states_([
					["Quick Load Off",Color.black,Color.white],
					["Quick Load On",Color.white,Color.black],
							]);

	~quickNetworkLoad0.action_({arg butt;
	if ( (butt.value == 0),
	{~quickLoadNetworkOn = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~quickLoadNetworkOn = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle input for control one on networked instance
	~networkInputSwitch0 = PopUpMenu(~w4, Rect(100, 100, 250/3, 25));
	~networkInputSwitch0.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch0.font_(Font("Monaco", 10));
	~networkInputSwitch0.background = Color.yellow.alpha_(0.8);

	~networkInputSwitch0.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector0 = 0;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector0 = 1;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector0 = 2;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control two on networked instance
	~networkInputSwitch1 = PopUpMenu(~w4, Rect(100 + (250/3), 100, 250/3, 25));
	~networkInputSwitch1.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch1.font_(Font("Monaco", 10));
	~networkInputSwitch1.background = Color.red.alpha_(0.8);
	~networkInputSwitch1.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch1.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector1 = 0;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector1 = 1;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector1 = 2;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control three/slave on networked instance
	~networkInputSwitch2 = PopUpMenu(~w4, Rect(100 + ((250/3) * 2), 100, 250/3, 25));
	~networkInputSwitch2.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch2.font_(Font("Monaco", 10));
	~networkInputSwitch2.background = Color.blue.alpha_(0.8);
	~networkInputSwitch2.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch2.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector2 = 0;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector2 = 1;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector2 = 2;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

	~w4.front;
	};);

		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sending to "  ++  field.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));	~textEditor.selectLine(~textEditor.string.size);			~textEditor.selectLine(~textEditor.string.size);
	};

	~ipOfSender5 = TextField(~w5, Rect(15, 90, 75, 15));
	~ipOfSender5.font_(Font("Monaco", 10));
	~ipOfSender5.string = "Send IP 6";
	~ipOfSender5.action = {arg field;
		~networkSender5 = NetAddr(field.value, 57120);

	~networkResponder5.remove;

	~networkResponder5 = OSCresponder(~networkSender5, '/return0', {| t, r, msg|
	{
	~networkReceived5 = [msg[1]];
	}.defer;
	}).add;

~outWindowCheck0 = ~outWindowCheck0 +1;

		if( ~outWindowCheck0 == 1,

	{

	~w4 = Window("Network Controls Out", Rect(70, 25, 350, 125), false, true, scroll: false);
	~w4.view.background_(Color.gray);
	~w4.userCanClose = false;
	~w4.alwaysOnTop = true;

	~receiverInText = StaticText(~w4, Rect(0, 5, 100, 75));
	~receiverInText.string = "out";
	~receiverInText.align = \center;
	~receiverInText.font = Font("Monaco", 50);
	~receiverInText.stringColor_(Color.black.alpha_(0.5));

// toggle network sync clock
	~networkClockSyncOut = Button(~w4, Rect(0, 75, 100, 25));
	~networkClockSyncOut.font_(Font("Monaco", 8.5));
     ~networkClockSyncOut.states_([["Sync Off", Color.white, Color.black.alpha_(0.8)], ["Sync On", Color.black.alpha_(0.8), Color.white]]);
     ~networkClockSyncOut.action_({arg butt;

	if (butt.value == 0,
	{

	~networkSyncOut0 = 0;

	});

	if(butt.value == 1,

	{

	~networkSyncOut0 = 1;

	});

	});

// toggle networked instance's network functionality
	~networkChangeSwitch0 = Button(~w4, Rect(0, 100, 100, 25));
	~networkChangeSwitch0.font_(Font("Monaco", 10));
	~networkChangeSwitch0.states_([
					["Network Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Network On", Color.green.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSwitch0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSwitchOut0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSwitchOut0 = 1;
	~textEditor.stringColor_(Color.green, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control one sample ugens on networked instances
	~networkChangeSample0 = Button(~w4, Rect(100, 0, 125, 25));
	~networkChangeSample0.font_(Font("Monaco", 10));
	~networkChangeSample0.states_([
					["Sample Change Off", Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["Sample Change On", Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);

	~networkChangeSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 1;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control two sample ugens on networked instances
	~networkChangeSample1 = Button(~w4, Rect(100, 25, 125, 25));
	~networkChangeSample1.font_(Font("Monaco", 10));
	~networkChangeSample1.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Sample Change On",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample1.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 2;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control three/slave sample ugens on networked instances
	~networkChangeSample2 = Button(~w4, Rect(100, 50, 125, 25));
	~networkChangeSample2.font_(Font("Monaco", 10));
	~networkChangeSample2.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["Sample Change On",Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample2.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 3;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// select sample from selected database on networked instance
	~networkChangeSelector0 = PopUpMenu(~w4, Rect(100, 75, 125, 25));
	~networkChangeSelector0.items = ["None","C Major Scale", "Don't You Want Me Baby", "Crockett Stereo"];
	~networkChangeSelector0.background_(Color.gray.alpha_(0.8));
	~networkChangeSelector0.font_(Font("Monaco", 10));
	~networkChangeSelector0.action = {arg menu;
			~networkSampleSelector0 = (menu.value)-1;

	};

// trigger live sampling on networked instance
	~networkRecordSample0 = Button(~w4, Rect(225, 0, 125, 25));
	~networkRecordSample0.font_(Font("Monaco", 10));
	~networkRecordSample0.states_([
					["Record Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Record On", Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkRecordSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkRecord0 = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkRecord0 = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Recording... ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// set length of live sample on networked instance
	~recordNetworkLengthInput0 = TextField(~w4, Rect(225, 25, 125, 25));
	~recordNetworkLengthInput0.font_(Font("Monaco", 10));
	~recordNetworkLengthInput0.string = "1.0";
	~recordNetworkLengthInput0.stringColor = Color.white.alpha_(0.8);
	~recordNetworkLengthInput0.background = Color.red.alpha_(0.8);
	~recordNetworkLengthInput0.action = {arg field;
		~recordNetworkLength0 = field.value.asInteger.max(1);
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Length = "  ++  field.value.asString ++ " seconds", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);
	};

// set destination of live sample recording on networked instance
	~quickNetworkLoadSelector0 = PopUpMenu(~w4, Rect(225, 50, 125, 25));
	~quickNetworkLoadSelector0.font_(Font("Monaco", 10));
	~quickNetworkLoadSelector0.items = ["to Yellow", "to Red", "to Blue"];
	~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
	~quickNetworkLoadSelector0.action = {arg menu;
		if (menu.value == 0,
		{

		~quickLoadNetworkValue = 0;

		~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.black.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Yellow ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 1,
		{

		~quickLoadNetworkValue = 1;

		~quickNetworkLoadSelector0.background = Color.red.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Red ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 2,
		{

		~quickLoadNetworkValue = 2;

		~quickNetworkLoadSelector0.background = Color.blue.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Blue ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);
	};

// load live sample to relative destination on networked instance
	~quickNetworkLoad0 = Button(~w4, Rect(225, 75, 125, 25));
	~quickNetworkLoad0.font_(Font("Monaco", 10));
	~quickNetworkLoad0.states_([
					["Quick Load Off",Color.black,Color.white],
					["Quick Load On",Color.white,Color.black],
							]);

	~quickNetworkLoad0.action_({arg butt;
	if ( (butt.value == 0),
	{~quickLoadNetworkOn = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~quickLoadNetworkOn = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle input for control one on networked instance
	~networkInputSwitch0 = PopUpMenu(~w4, Rect(100, 100, 250/3, 25));
	~networkInputSwitch0.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch0.font_(Font("Monaco", 10));
	~networkInputSwitch0.background = Color.yellow.alpha_(0.8);

	~networkInputSwitch0.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector0 = 0;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector0 = 1;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector0 = 2;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control two on networked instance
	~networkInputSwitch1 = PopUpMenu(~w4, Rect(100 + (250/3), 100, 250/3, 25));
	~networkInputSwitch1.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch1.font_(Font("Monaco", 10));
	~networkInputSwitch1.background = Color.red.alpha_(0.8);
	~networkInputSwitch1.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch1.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector1 = 0;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector1 = 1;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector1 = 2;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control three/slave on networked instance
	~networkInputSwitch2 = PopUpMenu(~w4, Rect(100 + ((250/3) * 2), 100, 250/3, 25));
	~networkInputSwitch2.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch2.font_(Font("Monaco", 10));
	~networkInputSwitch2.background = Color.blue.alpha_(0.8);
	~networkInputSwitch2.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch2.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector2 = 0;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector2 = 1;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector2 = 2;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

	~w4.front;
	};);

		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sending to "  ++  field.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));	~textEditor.selectLine(~textEditor.string.size);			~textEditor.selectLine(~textEditor.string.size);
	};

	~ipOfSender6 = TextField(~w5, Rect(15, 105, 75, 15));
	~ipOfSender6.font_(Font("Monaco", 10));
	~ipOfSender6.string = "Send IP 7";
	~ipOfSender6.action = {arg field;
		~networkSender6 = NetAddr(field.value, 57120);

	~networkResponder6.remove;

	~networkResponder6 = OSCresponder(~networkSender6, '/return0', {| t, r, msg|
	{
	~networkReceived6 = [msg[1]];
	}.defer;
	}).add;

		~outWindowCheck0 = ~outWindowCheck0 +1;

		if( ~outWindowCheck0 == 1,

	{

	~w4 = Window("Network Controls Out", Rect(70, 25, 350, 125), false, true, scroll: false);
	~w4.view.background_(Color.gray);
	~w4.userCanClose = false;
	~w4.alwaysOnTop = true;

	~receiverInText = StaticText(~w4, Rect(0, 5, 100, 75));
	~receiverInText.string = "out";
	~receiverInText.align = \center;
	~receiverInText.font = Font("Monaco", 50);
	~receiverInText.stringColor_(Color.black.alpha_(0.5));

// toggle network sync clock
	~networkClockSyncOut = Button(~w4, Rect(0, 75, 100, 25));
	~networkClockSyncOut.font_(Font("Monaco", 8.5));
     ~networkClockSyncOut.states_([["Sync Off", Color.white, Color.black.alpha_(0.8)], ["Sync On", Color.black.alpha_(0.8), Color.white]]);
     ~networkClockSyncOut.action_({arg butt;

	if (butt.value == 0,
	{

	~networkSyncOut0 = 0;

	});

	if(butt.value == 1,

	{

	~networkSyncOut0 = 1;

	});

	});

// toggle networked instance's network functionality
	~networkChangeSwitch0 = Button(~w4, Rect(0, 100, 100, 25));
	~networkChangeSwitch0.font_(Font("Monaco", 10));
	~networkChangeSwitch0.states_([
					["Network Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Network On", Color.green.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSwitch0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSwitchOut0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSwitchOut0 = 1;
	~textEditor.stringColor_(Color.green, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control one sample ugens on networked instances
	~networkChangeSample0 = Button(~w4, Rect(100, 0, 125, 25));
	~networkChangeSample0.font_(Font("Monaco", 10));
	~networkChangeSample0.states_([
					["Sample Change Off", Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["Sample Change On", Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);

	~networkChangeSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 1;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control two sample ugens on networked instances
	~networkChangeSample1 = Button(~w4, Rect(100, 25, 125, 25));
	~networkChangeSample1.font_(Font("Monaco", 10));
	~networkChangeSample1.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Sample Change On",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample1.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 2;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control three/slave sample ugens on networked instances
	~networkChangeSample2 = Button(~w4, Rect(100, 50, 125, 25));
	~networkChangeSample2.font_(Font("Monaco", 10));
	~networkChangeSample2.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["Sample Change On",Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample2.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 3;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// select sample from selected database on networked instance
	~networkChangeSelector0 = PopUpMenu(~w4, Rect(100, 75, 125, 25));
	~networkChangeSelector0.items = ["None","C Major Scale", "Don't You Want Me Baby", "Crockett Stereo"];
	~networkChangeSelector0.background_(Color.gray.alpha_(0.8));
	~networkChangeSelector0.font_(Font("Monaco", 10));
	~networkChangeSelector0.action = {arg menu;
			~networkSampleSelector0 = (menu.value)-1;

	};

// trigger live sampling on networked instance
	~networkRecordSample0 = Button(~w4, Rect(225, 0, 125, 25));
	~networkRecordSample0.font_(Font("Monaco", 10));
	~networkRecordSample0.states_([
					["Record Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Record On", Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkRecordSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkRecord0 = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkRecord0 = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Recording... ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// set length of live sample on networked instance
	~recordNetworkLengthInput0 = TextField(~w4, Rect(225, 25, 125, 25));
	~recordNetworkLengthInput0.font_(Font("Monaco", 10));
	~recordNetworkLengthInput0.string = "1.0";
	~recordNetworkLengthInput0.stringColor = Color.white.alpha_(0.8);
	~recordNetworkLengthInput0.background = Color.red.alpha_(0.8);
	~recordNetworkLengthInput0.action = {arg field;
		~recordNetworkLength0 = field.value.asInteger.max(1);
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Length = "  ++  field.value.asString ++ " seconds", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);
	};

// set destination of live sample recording on networked instance
	~quickNetworkLoadSelector0 = PopUpMenu(~w4, Rect(225, 50, 125, 25));
	~quickNetworkLoadSelector0.font_(Font("Monaco", 10));
	~quickNetworkLoadSelector0.items = ["to Yellow", "to Red", "to Blue"];
	~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
	~quickNetworkLoadSelector0.action = {arg menu;
		if (menu.value == 0,
		{

		~quickLoadNetworkValue = 0;

		~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.black.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Yellow ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 1,
		{

		~quickLoadNetworkValue = 1;

		~quickNetworkLoadSelector0.background = Color.red.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Red ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 2,
		{

		~quickLoadNetworkValue = 2;

		~quickNetworkLoadSelector0.background = Color.blue.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Blue ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);
	};

// load live sample to relative destination on networked instance
	~quickNetworkLoad0 = Button(~w4, Rect(225, 75, 125, 25));
	~quickNetworkLoad0.font_(Font("Monaco", 10));
	~quickNetworkLoad0.states_([
					["Quick Load Off",Color.black,Color.white],
					["Quick Load On",Color.white,Color.black],
							]);

	~quickNetworkLoad0.action_({arg butt;
	if ( (butt.value == 0),
	{~quickLoadNetworkOn = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~quickLoadNetworkOn = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle input for control one on networked instance
	~networkInputSwitch0 = PopUpMenu(~w4, Rect(100, 100, 250/3, 25));
	~networkInputSwitch0.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch0.font_(Font("Monaco", 10));
	~networkInputSwitch0.background = Color.yellow.alpha_(0.8);

	~networkInputSwitch0.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector0 = 0;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector0 = 1;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector0 = 2;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control two on networked instance
	~networkInputSwitch1 = PopUpMenu(~w4, Rect(100 + (250/3), 100, 250/3, 25));
	~networkInputSwitch1.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch1.font_(Font("Monaco", 10));
	~networkInputSwitch1.background = Color.red.alpha_(0.8);
	~networkInputSwitch1.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch1.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector1 = 0;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector1 = 1;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector1 = 2;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control three/slave on networked instance
	~networkInputSwitch2 = PopUpMenu(~w4, Rect(100 + ((250/3) * 2), 100, 250/3, 25));
	~networkInputSwitch2.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch2.font_(Font("Monaco", 10));
	~networkInputSwitch2.background = Color.blue.alpha_(0.8);
	~networkInputSwitch2.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch2.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector2 = 0;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector2 = 1;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector2 = 2;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

	~w4.front;
	};);
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sending to "  ++  field.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));	~textEditor.selectLine(~textEditor.string.size);			~textEditor.selectLine(~textEditor.string.size);
	};

	~ipOfSender7 = TextField(~w5, Rect(15, 120, 75, 15));
	~ipOfSender7.font_(Font("Monaco", 10));
	~ipOfSender7.string = "Send IP 8";
	~ipOfSender7.action = {arg field;
		~networkSender7 = NetAddr(field.value, 57120);

	~networkResponder7.remove;

	~networkResponder7 = OSCresponder(~networkSender7, '/return0', {| t, r, msg|
	{
	~networkReceived7 = [msg[1]];
	}.defer;
	}).add;

		~outWindowCheck0 = ~outWindowCheck0 +1;

		if( ~outWindowCheck0 == 1,

	{

	~w4 = Window("Network Controls Out", Rect(70, 25, 350, 125), false, true, scroll: false);
	~w4.view.background_(Color.gray);
	~w4.userCanClose = false;
	~w4.alwaysOnTop = true;

	~receiverInText = StaticText(~w4, Rect(0, 5, 100, 75));
	~receiverInText.string = "out";
	~receiverInText.align = \center;
	~receiverInText.font = Font("Monaco", 50);
	~receiverInText.stringColor_(Color.black.alpha_(0.5));

// toggle network sync clock
	~networkClockSyncOut = Button(~w4, Rect(0, 75, 100, 25));
	~networkClockSyncOut.font_(Font("Monaco", 8.5));
     ~networkClockSyncOut.states_([["Sync Off", Color.white, Color.black.alpha_(0.8)], ["Sync On", Color.black.alpha_(0.8), Color.white]]);
     ~networkClockSyncOut.action_({arg butt;

	if (butt.value == 0,
	{

	~networkSyncOut0 = 0;

	});

	if(butt.value == 1,

	{

	~networkSyncOut0 = 1;

	});

	});

// toggle networked instance's network functionality
	~networkChangeSwitch0 = Button(~w4, Rect(0, 100, 100, 25));
	~networkChangeSwitch0.font_(Font("Monaco", 10));
	~networkChangeSwitch0.states_([
					["Network Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Network On", Color.green.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSwitch0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSwitchOut0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSwitchOut0 = 1;
	~textEditor.stringColor_(Color.green, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Mappings On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control one sample ugens on networked instances
	~networkChangeSample0 = Button(~w4, Rect(100, 0, 125, 25));
	~networkChangeSample0.font_(Font("Monaco", 10));
	~networkChangeSample0.states_([
					["Sample Change Off", Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["Sample Change On", Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);

	~networkChangeSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 1;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control two sample ugens on networked instances
	~networkChangeSample1 = Button(~w4, Rect(100, 25, 125, 25));
	~networkChangeSample1.font_(Font("Monaco", 10));
	~networkChangeSample1.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Sample Change On",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample1.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 2;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle sample changes for control three/slave sample ugens on networked instances
	~networkChangeSample2 = Button(~w4, Rect(100, 50, 125, 25));
	~networkChangeSample2.font_(Font("Monaco", 10));
	~networkChangeSample2.states_([
					["Sample Change Off",Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["Sample Change On",Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeSample2.action_({arg butt;
	if ( (butt.value == 0),
	{~networkSampleChange0 = 0;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkSampleChange0 = 3;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sample Change Sending ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// select sample from selected database on networked instance
	~networkChangeSelector0 = PopUpMenu(~w4, Rect(100, 75, 125, 25));
	~networkChangeSelector0.items = ["None","C Major Scale", "Don't You Want Me Baby", "Crockett Stereo"];
	~networkChangeSelector0.background_(Color.gray.alpha_(0.8));
	~networkChangeSelector0.font_(Font("Monaco", 10));
	~networkChangeSelector0.action = {arg menu;
			~networkSampleSelector0 = (menu.value)-1;

	};

// trigger live sampling on networked instance
	~networkRecordSample0 = Button(~w4, Rect(225, 0, 125, 25));
	~networkRecordSample0.font_(Font("Monaco", 10));
	~networkRecordSample0.states_([
					["Record Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Record On", Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkRecordSample0.action_({arg butt;
	if ( (butt.value == 0),
	{~networkRecord0 = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~networkRecord0 = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Recording... ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// set length of live sample on networked instance
	~recordNetworkLengthInput0 = TextField(~w4, Rect(225, 25, 125, 25));
	~recordNetworkLengthInput0.font_(Font("Monaco", 10));
	~recordNetworkLengthInput0.string = "1.0";
	~recordNetworkLengthInput0.stringColor = Color.white.alpha_(0.8);
	~recordNetworkLengthInput0.background = Color.red.alpha_(0.8);
	~recordNetworkLengthInput0.action = {arg field;
		~recordNetworkLength0 = field.value.asInteger.max(1);
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Record Length = "  ++  field.value.asString ++ " seconds", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);
	};

// set destination of live sample recording on networked instance
	~quickNetworkLoadSelector0 = PopUpMenu(~w4, Rect(225, 50, 125, 25));
	~quickNetworkLoadSelector0.font_(Font("Monaco", 10));
	~quickNetworkLoadSelector0.items = ["to Yellow", "to Red", "to Blue"];
	~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
	~quickNetworkLoadSelector0.action = {arg menu;
		if (menu.value == 0,
		{

		~quickLoadNetworkValue = 0;

		~quickNetworkLoadSelector0.background = Color.yellow.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.black.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Yellow ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 1,
		{

		~quickLoadNetworkValue = 1;

		~quickNetworkLoadSelector0.background = Color.red.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Red ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);

		if (menu.value == 2,
		{

		~quickLoadNetworkValue = 2;

		~quickNetworkLoadSelector0.background = Color.blue.alpha_(0.8);
		~quickNetworkLoadSelector0.stringColor = Color.white.alpha_(0.8);

	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load set to Blue ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

		};);
	};

// load live sample to relative destination on networked instance
	~quickNetworkLoad0 = Button(~w4, Rect(225, 75, 125, 25));
	~quickNetworkLoad0.font_(Font("Monaco", 10));
	~quickNetworkLoad0.states_([
					["Quick Load Off",Color.black,Color.white],
					["Quick Load On",Color.white,Color.black],
							]);

	~quickNetworkLoad0.action_({arg butt;
	if ( (butt.value == 0),
	{~quickLoadNetworkOn = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	if ( (butt.value == 1),
	{~quickLoadNetworkOn = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Load On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// toggle input for control one on networked instance
	~networkInputSwitch0 = PopUpMenu(~w4, Rect(100, 100, 250/3, 25));
	~networkInputSwitch0.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch0.font_(Font("Monaco", 10));
	~networkInputSwitch0.background = Color.yellow.alpha_(0.8);

	~networkInputSwitch0.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector0 = 0;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector0 = 1;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector0 = 2;
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control two on networked instance
	~networkInputSwitch1 = PopUpMenu(~w4, Rect(100 + (250/3), 100, 250/3, 25));
	~networkInputSwitch1.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch1.font_(Font("Monaco", 10));
	~networkInputSwitch1.background = Color.red.alpha_(0.8);
	~networkInputSwitch1.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch1.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector1 = 0;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector1 = 1;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector1 = 2;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// toggle input for control three/slave on networked instance
	~networkInputSwitch2 = PopUpMenu(~w4, Rect(100 + ((250/3) * 2), 100, 250/3, 25));
	~networkInputSwitch2.items = ["Sample", "Synth", "Mic"];
	~networkInputSwitch2.font_(Font("Monaco", 10));
	~networkInputSwitch2.background = Color.blue.alpha_(0.8);
	~networkInputSwitch2.stringColor = Color.white.alpha_(0.8);

	~networkInputSwitch2.action_({arg menu;
	if ( menu.value == 0,
	{
		~networkInputSelector2 = 0;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Sample "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{
		~networkInputSelector2 = 1;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Synth "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{
		~networkInputSelector2 = 2;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue set to Mic "  ++ " ", (~textEditor.string.size),
	(~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

	~w4.front;
	};);

		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Sending to "  ++  field.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));	~textEditor.selectLine(~textEditor.string.size);			~textEditor.selectLine(~textEditor.string.size);
	};

	~senderText = StaticText(~w5, Rect(15, 0, 75, 15));
	~senderText.string = "SEND";
	~senderText.font = Font("Monaco", 14);
	~senderText.stringColor_(Color.green);

// network settings of receiver and windows
	~ipOfReceiver = TextField(~w5, Rect(15, 150, 75, 15));
	~ipOfReceiver.font_(Font("Monaco", 10));
	~ipOfReceiver.string = "From IP";
	~ipOfReceiver.action = {arg field;
	~networkReceiver0 = NetAddr(field.value, 57120);
	~networkReturn0 = NetAddr(field.value, 57120);

		~inWindowCheck0 = ~inWindowCheck0 +1;

		if( ~inWindowCheck0 == 1,

	{

	~w0 = Window("Network Controls In", Rect(70, 25, 350, 125), false, true, scroll: false);
	~w0.view.background_(Color.gray);
	~w0.userCanClose = false;
	~w0.alwaysOnTop = true;

	~receiverOutText = StaticText(~w0, Rect(10, 5, 75, 75));
	~receiverOutText.string = "in";
	~receiverOutText.align = \center;
	~receiverOutText.font = Font("Monaco", 50);
	~receiverOutText.stringColor_(Color.black.alpha_(0.5));

// display status of networked network toggle
	~networkSwitchOn0 = Button(~w0, Rect(0, 100, 100, 25));
	~networkSwitchOn0.font_(Font("Monaco", 10));
	~networkSwitchOn0.states_([
					["Network Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Network On",Color.green.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkSwitchOn0.action_({arg butt;
	if ( butt.value == 0,
	{
		~networkSelector0 = 0; ~bufferSynth.set(\networkChooser0, 0);

		~networkUpdate0.stop;
		~networkUpdate0.reset;
		~attackText0[23].stringColor_(Color.yellow);
		~attackText0[24].stringColor_(Color.blue);
		~onText0.stringColor_(Color.red);
		~networkText0.remove;
		~networkText1.remove;
		~networkText2.remove;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Receive Off "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));	~textEditor.selectLine(~textEditor.string.size);									~textEditor.selectLine(~textEditor.string.size);
		},

// display status of networked network toggle is one, use networked data
	{~networkSelector0 = 1; ~bufferSynth.set(\networkChooser0, 1);

		~textEditor.stringColor_(Color.green, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Receive On "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));	~textEditor.selectLine(~textEditor.string.size);
		~textEditor.selectLine(~textEditor.string.size);

// receive triggers of networked control one
	~triggerResponder0 = OSCresponder(~networkReceiver0, '/triggers0', {| t, r, msg|
	{
	~trigger0Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive triggers of networked control two
	~triggerResponder1 = OSCresponder(~networkReceiver0, '/triggers1', {| t, r, msg|
	{
	~trigger1Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive triggers of networked control three/slave
	~triggerResponder2 = OSCresponder(~networkReceiver0, '/triggers2', {| t, r, msg|
	{
	~grainTriggerReply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive spectral following of networked control one
	~filterResponder0 = OSCresponder(~networkReceiver0, '/filters0', {| t, r, msg|
	{
	~filter0Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive spectral following of networked control two
	~filterResponder1 = OSCresponder(~networkReceiver0, '/filters1', {| t, r, msg|
	{
	~filter1Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive spectral following of networked control three/slave
	~filterResponder2 = OSCresponder(~networkReceiver0, '/filters2', {| t, r, msg|
	{
	~filter2Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive MFCC of networked control one
	~mfccDataResponder0 = OSCresponder(~networkReceiver0, '/mfccData0', {| t, r, msg|
	{
	~mfccData0Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13], msg[14]];
	}.defer;
	}).add;

// receive MFCC of networked control two
	~mfccDataResponder1 = OSCresponder(~networkReceiver0, '/mfccData1', {| t, r, msg|
	{
	~mfccData1Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13], msg[14]];
	}.defer;
	}).add;

// receive MFCC of networked control three/slave
	~mfccDataResponder2 = OSCresponder(~networkReceiver0, '/mfccData2', {| t, r, msg|
	{
	~mfccData2Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive pitch of networked control one
	~pitchResponder0 = OSCresponder(~networkReceiver0, '/pitch0', {| t, r, msg|
	{
	~pitchReply0 = [msg[1], msg[2], msg[3]];
	}.defer;
	}).add;

// receive clock of networked instance
	~clockResponder0 = OSCresponder(~networkReceiver0, '/clock0', {| t, r, msg|
	{
	~clockReply0 = [msg[1], msg[2], msg[3]];
	}.defer;
	}).add;

// receive selected variables of networked instance
	~systemResponder0 = OSCresponder(~networkReceiver0, '/system0', {| t, r, msg|
	{
	~systemReply0 = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11]];
	}.defer;
	}).add;

// set networked values in local instance
	~networkUpdate0 = Task({
	loop{
		(1/60).wait;
		~granularMacroSynth0.set(\networkOnsets0, ~trigger0Reply);
		~granularMacroSynth1.set(\networkOnsets1, ~trigger1Reply);
		~granularMacroSynth2.set(\networkOnsets2, ~grainTriggerReply);

		~envelopeSynth.set(\networkOnsets0, ~trigger0Reply);
		~envelopeSynth.set(\networkOnsets1, ~trigger1Reply);
		~envelopeSynth.set(\networkOnsets2, ~grainTriggerReply);

		~bufferSynth.set(\networkOnsets0, ~trigger0Reply);
		~bufferSynth.set(\networkOnsets1, ~trigger1Reply);
		~bufferSynth.set(\networkOnsets2, ~grainTriggerReply);

		~analysisSynth.set(\networkFilters0, ~filter0Reply);
		~analysisSynth.set(\networkFilters1, ~filter1Reply);
		~analysisSynth.set(\networkFilters2, ~filter2Reply);

		~granularMacroSynth0.set(\networkFilters0, ~filter0Reply);
		~granularMacroSynth1.set(\networkFilters1, ~filter1Reply);
		~granularMacroSynth2.set(\networkFilters2, ~filter2Reply);

		~pan0Synth.set(\networkFilters0, ~filter0Reply);
		~pan1Synth.set(\networkFilters1, ~filter1Reply);
		~pan2Synth.set(\networkFilters2, ~filter2Reply);

		~bufferSynth.set(\networkPitch0, ~pitchReply0);

			};
		}).start;

		~attackText0[24].stringColor_(Color.blue.alpha_(0.0));
		~attackText0[23].stringColor_(Color.yellow.alpha_(0.0));
		~onText0.stringColor_(Color.red.alpha_(0.0));
		~networkText0 = StaticText(~w1, Rect(26, 26, (1920/3)-50, height-78));
		~networkText1 = StaticText(~w1, Rect((640)+25, 26, (1920/3)-50, height-78));
		~networkText2 = StaticText(~w1, Rect(1280+25, 26, (1920/3)-50, height-78));
		~networkText0.string = "network receive on";
		~networkText1.string = "network receive on";
		~networkText2.string = "network receive on";
		~networkText0.stringColor_(Color.gray);
		~networkText0.font_(Font("Monaco", 50));
		~networkText1.stringColor_(Color.gray);
		~networkText1.font_(Font("Monaco", 50));
		~networkText2.stringColor_(Color.gray);
		~networkText2.font_(Font("Monaco", 50));

	}
	)
	});

// Display received clock toggle value
	~networkClockSyncIn = Button(~w0, Rect(0, 75, 100, 25));
	~networkClockSyncIn.font_(Font("Monaco", 8.5));
     ~networkClockSyncIn.states_([["Sync Off", Color.white, Color.black.alpha_(0.8)], ["Sync On", Color.black.alpha_(0.8), Color.white]]);
     ~networkClockSyncIn.action_({arg butt;

	if (butt.value == 0,
	{
	~syncSelector0 = 0;
	~clockSyncTask.stop;
	~clockStop.valueAction = 0;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Local Clock ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);

	});

	if(butt.value == 1,

	{
	~syncSelector0 = 1;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Clock Is Synced ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~clockStop.valueAction = 0;
	~clockSyncTask.play;

	});

	});

// Display and set received sample change for control one
	~networkChangeReceive0 = Button(~w0, Rect(100, 0, 125, 25));
	~networkChangeReceive0.font_(Font("Monaco", 10));
	~networkChangeReceive0.states_([
					["",Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["Sample Changed",Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);

	~networkChangeReceive0.action_({arg butt;

	if ( (butt.value == 1) && (~receiverButton.value == 1),
	{

	{
	c.free;
	~samplePath0 = ["/Users/Julian/Documents/University/PhD Research/Genesis/Sounds/Harmonic/C Major Scale.aif", "/Users/Julian/Documents/University/PhD Research/Genesis/Sounds/Harmonic/Don't You Want Me Baby.aif", "/Users/Julian/Documents/University/PhD Research/Genesis/Sounds/Harmonic/Crockett Stereo.aif"].at(~networkSampleSelectorReceive0);
	c.allocRead(~samplePath0.asString);
	~sampleFile0.openRead(~samplePath0.asString);
	~sampleViewer0.soundfile = ~sampleFile0;
	~sampleViewer0.read(0, ~sampleFile0.numFrames);
	~sampleViewer0.refresh;
	~cnumFrames = ~sampleFile0.numFrames;
	~samplePathButton0.states_([[~samplePath0.asString, Color.black.alpha_(0.5), Color.yellow.alpha_(0.8)]]);
	~bufferSynth.set(\start0, 0, \end0, ~sampleFile0.numFrames);
	~dna0.add(1);}.defer;

	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Sample Changed to " ++ ~samplePath0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// Display and set received sample change for control two
	~networkChangeReceive1 = Button(~w0, Rect(100, 25, 125, 25));
	~networkChangeReceive1.font_(Font("Monaco", 10));
	~networkChangeReceive1.states_([
					["",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Sample Changed",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeReceive1.action_({arg butt;

	if ( (butt.value == 1) && (~receiverButton.value == 1),
	{

	{
	d.free;
	~samplePath1 = ["/Users/Julian/Documents/University/PhD Research/Genesis/Sounds/Harmonic/C Major Scale.aif", "/Users/Julian/Documents/University/PhD Research/Genesis/Sounds/Harmonic/Don't You Want Me Baby.aif", "/Users/Julian/Documents/University/PhD Research/Genesis/Sounds/Harmonic/Crockett Stereo.aif"].at(~networkSampleSelectorReceive0);
	d.allocRead(~samplePath1.asString);
	~sampleFile1.openRead(~samplePath1.asString);
	~sampleViewer1.soundfile = ~sampleFile1;
	~sampleViewer1.read(0, ~sampleFile1.numFrames);
	~sampleViewer1.refresh;
	~dnumFrames = ~sampleFile1.numFrames;
	~samplePathButton1.states_([[~samplePath1.asString, Color.white, Color.red.alpha_(0.8)]]);
	~bufferSynth.set(\start1, 0, \end1, ~sampleFile1.numFrames);
	~dna1.add(1);}.defer;

	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Sample Changed to " ++ ~samplePath0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// Display and set received sample change for control three/slave
	~networkChangeReceive2 = Button(~w0, Rect(100, 50, 125, 25));
	~networkChangeReceive2.font_(Font("Monaco", 10));
	~networkChangeReceive2.states_([
					["",Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["Sample Changed",Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkChangeReceive2.action_({arg butt;

	if ( (butt.value == 1) && (~receiverButton.value == 1),
	{

	{
	b.free;
	~samplePath2 = ["/Users/Julian/Documents/University/PhD Research/Genesis/Sounds/Harmonic/C Major Scale.aif", "/Users/Julian/Documents/University/PhD Research/Genesis/Sounds/Harmonic/Don't You Want Me Baby.aif", "/Users/Julian/Documents/University/PhD Research/Genesis/Sounds/Harmonic/Crockett Stereo.aif"].at(~networkSampleSelectorReceive0);
	b.allocRead(~samplePath2.asString);
	~sampleFile2.openRead(~samplePath2.asString);
	~sampleViewer2.soundfile = ~sampleFile2;
	~sampleViewer2.read(0, ~sampleFile2.numFrames);
	~sampleViewer2.refresh;
	~bnumFrames = ~sampleFile2.numFrames;
	~samplePathButton2.states_([[~samplePath2.asString, Color.white, Color.blue.alpha_(0.8)]]);
	~bufferSynth.set(\start2, 0, \end2, ~sampleFile2.numFrames);
	~start = 0;
	~length = ~sampleFile2.numFrames;
	~child.add(1);}.defer;

	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Sample Changed to " ++ ~samplePath0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);});

	});

// Display and set received live sampling toggle
	~networkRecordButton0 = Button(~w0, Rect(225, 0, 125, 25));
	~networkRecordButton0.font_(Font("Monaco", 10));
	~networkRecordButton0.states_([
					["Record Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Record On",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~networkRecordButton0.action_({arg butt;
	if ( butt.value == 1,
	{~recordBuffer0.free;
		~recordBuffer0 = Buffer.alloc(s, s.sampleRate * ~recordNetworkLengthReceive0.value.asInteger.max(1), 2, bufnum:226);
		~fxSynth.set(\recordOn, 1); ~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Recording... ", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size); },
	{~fxSynth.set(\recordOn, 0); ~recordBuffer0.write(sampleFormat: 'int16'); ~quickLoadPath0 = (thisProcess.platform.recordingsDir +/+ "SC_" ++ Date.localtime.stamp ++ ".aiff");
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Recording Saved as " ++ ("SC_" ++ Date.localtime.stamp.asString ++ ".aiff"), (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);}
	)
	});

// Display and set received live sampling duration
	~recordNetworkLengthReceive0 = TextField(~w0, Rect(225, 25, 125, 25));
	~recordNetworkLengthReceive0.font_(Font("Monaco", 10));
	~recordNetworkLengthReceive0.string = "1.0";
	~recordNetworkLengthReceive0.value = 1.0;
	~recordNetworkLengthReceive0.stringColor = Color.white.alpha_(0.8);
	~recordNetworkLengthReceive0.background = Color.red.alpha_(0.8);
	~recordNetworkLengthReceive0.action = {arg field;
			~recordNetworkLengthReceive0.value = field.value.asInteger.max(1);
	};

	~quickLoadReceiveSelector0 = PopUpMenu(~w0, Rect(225, 50, 125, 25));
	~quickLoadReceiveSelector0.font_(Font("Monaco", 10));
	~quickLoadReceiveSelector0.items = ["to Yellow", "to Red", "to Blue"];
	~quickLoadReceiveSelector0.background = Color.yellow.alpha_(0.8);
	~quickLoadReceiveSelector0.action = {arg menu;
		if (menu.value == 0,
		{	~bufferSelector0 = c;
			~sampleSelector0 = ~sampleViewer0;
			~sampleFileSelected = ~sampleFile0;
			~numFramesSelector = ~cnumFrames;
			~dnaSelector0 = ~dna0;
			~loadSelector0 = "Yellow";
			~quickLoadReceiveSelector0.background = Color.yellow.alpha_(0.8);
			~quickLoadReceiveSelector0.stringColor = Color.black.alpha_(0.8);

		};);

		if (menu.value == 1,
		{	~bufferSelector0 = d;
			~sampleSelector0 = ~sampleViewer1;
			~sampleFileSelected = ~sampleFile1;
			~numFramesSelector = ~dnumFrames;
			~dnaSelector0 = ~dna1;
			~loadSelector0 = "Red";
			~quickLoadReceiveSelector0.background = Color.red.alpha_(0.8);
			~quickLoadReceiveSelector0.stringColor = Color.white.alpha_(0.8);
		};);

		if (menu.value == 2,
		{	~bufferSelector0 = b;
			~sampleSelector0 = ~sampleViewer2;
			~sampleFileSelected = ~sampleFile2;
			~numFramesSelector = ~bnumFrames;
			~dnaSelector0 = ~child;
			~loadSelector0 = "Blue";
			~quickLoadReceiveSelector0.background = Color.blue.alpha_(0.8);
			~quickLoadReceiveSelector0.stringColor = Color.white.alpha_(0.8);
		};);
	};

// Display and set received live sampling to relative destination
	~quickLoadReceive0 = Button(~w0, Rect(225, 75, 125, 25));
	~quickLoadReceive0.font_(Font("Monaco", 10));
	~quickLoadReceive0.states_([
					["Quick Load Off",Color.black,Color.white],
					["Quick Load On",Color.white,Color.black],
							]);

	~quickLoadReceive0.action_({arg butt;

	if(butt.value == 1,
	{
	~bufferSelector0.free;
	~bufferSelector0.allocRead(~quickLoadPath0.asString);
	~sampleFileSelected.openRead(~quickLoadPath0.asString);
	~sampleSelector0.soundfile = ~sampleFileSelected;
	~sampleSelector0.read(0, ~sampleFileSelected.numFrames);
	~sampleSelector0.refresh;
	~numFramesSelector = ~sampleFileSelected.numFrames;
	~bufferSynth.set("start" ++ ~quickLoadReceiveSelector0.value.asString, 0, "end" ++ ~quickLoadReceiveSelector0.value.asString, ~sampleFileSelected.numFrames);
	});
	if((~quickLoadReceiveSelector0.value) == 0 && (butt.value == 1),
	{~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Loaded File to "  ++  ~loadSelector0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});
	if((~quickLoadReceiveSelector0.value == 1) && (butt.value == 1),
	{~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Loaded File to "  ++  ~loadSelector0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});
	if((~quickLoadReceiveSelector0.value == 2) && (butt.value == 1),
	{~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Quick Loaded File to "  ++  ~loadSelector0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});
	if (~bufferSelector0 == b,
	{~length = ~sampleFileSelected.numFrames;
	 ~start = 0; };
	);
	~dnaSelector0.add(1);
	});

// Display and set received input for control one
	~networkReceiveInput0 = PopUpMenu(~w0, Rect(100, 100, 250/3, 25));
	~networkReceiveInput0 .items = ["Sample", "Synth", "Mic"];
	~networkReceiveInput0 .font_(Font("Monaco", 10));
	~networkReceiveInput0 .background = Color.yellow.alpha_(0.8);

	~networkReceiveInput0.action_({arg menu;
	if ( menu.value == 0,
	{~bufferSynth.set(\osc0Chooser0, 0); ~attackText0[23].string_("sample on"); ~sampleViewer0.drawsWaveForm_(true); ~sampleViewer0.setSelectionColor(0, Color.white.alpha_(0.8));
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Sample "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 1,
	{~bufferSynth.set(\osc0Chooser0, 1); ~attackText0[23].string_("synth on"); ~sampleViewer0.drawsWaveForm_(false); ~sampleViewer0.setSelectionColor(0, Color.clear);
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow Set to Synth "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	if ( menu.value == 2,
	{~bufferSynth.set(\osc0Chooser0, 2); ~attackText0[23].string_("mic input on"); ~sampleViewer0.drawsWaveForm_(false); ~sampleViewer0.setSelectionColor(0, Color.clear);
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Yellow set to Mic "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	};
	);
	});

// Display and set received input for control two
	~networkReceiveInput1 = PopUpMenu(~w0, Rect(100 + (250/3), 100, 250/3, 25));
	~networkReceiveInput1.items = ["Sample", "Synth", "Mic"];
	~networkReceiveInput1.font_(Font("Monaco", 10));
	~networkReceiveInput1.background = Color.red.alpha_(0.8);
	~networkReceiveInput1.stringColor = Color.white.alpha_(0.8);

	~networkReceiveInput1.action_({arg menu;
	if ( menu.value == 0,
	{~bufferSynth.set(\osc1Chooser0, 0); ~onText0.string_("sample on"); ~sampleViewer1.drawsWaveForm_(true); ~sampleViewer1.setSelectionColor(0, Color.white.alpha_(0.8));
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Sample "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);		};
	);
	if ( menu.value == 1,
	{~bufferSynth.set(\osc1Chooser0, 1); ~onText0.string_("synth on"); ~sampleViewer1.drawsWaveForm_(false); ~sampleViewer1.setSelectionColor(0, Color.clear);
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Synth "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);		}
	);
	if ( menu.value == 2,
	{~bufferSynth.set(\osc1Chooser0, 2); ~onText0.string_("mic input on"); ~sampleViewer1.drawsWaveForm_(false); ~sampleViewer1.setSelectionColor(0, Color.clear);
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Red Set to Mic "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);		}
	);
	});

// Display and set received input for control three/slave
	~networkReceiveInput2 = PopUpMenu(~w0, Rect(100 + (250/3 *2), 100, 250/3, 25));
	~networkReceiveInput2.items = ["Sample", "Synth", "Mic"];
	~networkReceiveInput2.font_(Font("Monaco", 10));
	~networkReceiveInput2.background = Color.blue.alpha_(0.8);
	~networkReceiveInput2.stringColor = Color.white.alpha_(0.8);

	~networkReceiveInput2.action_({arg menu;
	if ( menu.value == 0,
	{~bufferSynth.set(\osc2Chooser0, 0); ~attackText0[24].string_("sample on"); ~sampleViewer2.drawsWaveForm_(true); ~bufferSynth.set(\tempoChooser0, 0); ~sampleViewer2.setSelectionColor(0, Color.white.alpha_(0.8));
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Sample "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);		};
	);

	if ( menu.value == 1,
	{~bufferSynth.set(\osc2Chooser0, 1); ~attackText0[24].string_("synth on"); ~bufferSynth.set(\synthMicChooser0, 0); ~sampleViewer2.drawsWaveForm_(false); ~bufferSynth.set(\tempoChooser0, 1); ~sampleViewer2.setSelectionColor(0, Color.clear);
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Synth "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);		};
	);

	if ( menu.value == 2,
	{~bufferSynth.set(\osc2Chooser0, 1); ~attackText0[24].string_("mic input on"); ~bufferSynth.set(\synthMicChooser0, 1); ~sampleViewer2.drawsWaveForm_(false);  ~length = ~inputBuffer.numFrames; ~start = 0;  ~bufferSynth.set(\tempoChooser0, 2); ~sampleViewer2.setSelectionColor(0, Color.clear);
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Network Control Blue Set to Mic "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);		};
	);
	});

	~receiverInProtect = Button(~w0, Rect(0, 0, 400, 125));
	~receiverInProtect.font_(Font("Monaco", 10));
	~receiverInProtect.states_([
					["", Color.gray.alpha_(0),Color.gray.alpha_(0)],
							]);

// collect and set values of Network In window
	~systemNetworkUpdate0 = Task({
	loop{
		(1/60).wait;

		if(~systemReply0[0] == 0,

		{
			{~networkChangeReceive0.valueAction = 0}.defer;
			{~networkChangeReceive1.valueAction = 0}.defer;
			{~networkChangeReceive2.valueAction = 0}.defer;
		});

		if(~systemReply0[0] == 1,

		{
			{~networkChangeReceive0.valueAction = 1}.defer;
		});

		if(~systemReply0[0] == 2,

		{
			{~networkChangeReceive1.valueAction = 1}.defer;
		});

		if(~systemReply0[0] == 3,

		{
			{~networkChangeReceive2.valueAction = 1}.defer;
		});

		if(~systemReply0[1] == 0,

		{
			~networkSampleSelectorReceive0 = 0;
		});

		if(~systemReply0[1] == 1,

		{
			~networkSampleSelectorReceive0 = 1;
		});

		if(~systemReply0[1] == 2,

		{
			~networkSampleSelectorReceive0 = 2;
		});

		if(~systemReply0[2] == 0,

		{
			{~networkRecordButton0.valueAction = 0}.defer;
		});

		if(~systemReply0[2] == 1,

		{
			{~networkRecordButton0.valueAction = 1}.defer;
		});

		{~recordNetworkLengthReceive0.valueAction = ~systemReply0[3]}.defer;

		if(~systemReply0[4] == 0,

		{
			{~quickLoadReceive0.valueAction = 0}.defer;
		});

		if(~systemReply0[4] == 1,

		{
			{~quickLoadReceive0.valueAction = 1}.defer;
		});

		if(~systemReply0[5] == 0,

		{
			{~quickLoadReceiveSelector0.valueAction = 0}.defer;
		});

		if(~systemReply0[5] == 1,

		{
			{~quickLoadReceiveSelector0.valueAction = 1}.defer;
		});

		if(~systemReply0[5] == 2,

		{
			{~quickLoadReceiveSelector0.valueAction = 2}.defer;
		});

		{~networkReceiveInput0.valueAction = ~systemReply0[6]}.defer;
		{~networkReceiveInput1.valueAction = ~systemReply0[7]}.defer;
		{~networkReceiveInput2.valueAction = ~systemReply0[8]}.defer;
		{~networkSwitchOn0.valueAction = ~systemReply0[9]}.defer;
		{~networkClockSyncIn.valueAction = ~systemReply0[10]}.defer;
			};

		}).start;

		~w0.front;

	});

		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Receiving From "  ++  field.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));	~textEditor.selectLine(~textEditor.string.size);		~textEditor.selectLine(~textEditor.string.size);

	~triggerResponder0.remove;
	~triggerResponder1.remove;
	~triggerResponder2.remove;
	~filterResponder0.remove;
	~filterResponder1.remove;
	~filterResponder2.remove;
	~mfccDataResponder0.remove;
	~mfccDataResponder1.remove;
	~mfccDataResponder2.remove;
	~pitchResponder0.remove;
	~clockResponder0.remove;
	~systemResponder0.remove;

// receive triggers of networked control one
	~triggerResponder0 = OSCresponder(~networkReceiver0, '/triggers0', {| t, r, msg|
	{
	~trigger0Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive triggers of networked control two
	~triggerResponder1 = OSCresponder(~networkReceiver0, '/triggers1', {| t, r, msg|
	{
	~trigger1Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive triggers of networked control three/slave
	~triggerResponder2 = OSCresponder(~networkReceiver0, '/triggers2', {| t, r, msg|
	{
	~grainTriggerReply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive spectral following of networked control one
	~filterResponder0 = OSCresponder(~networkReceiver0, '/filters0', {| t, r, msg|
	{
	~filter0Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive spectral following of networked control two
	~filterResponder1 = OSCresponder(~networkReceiver0, '/filters1', {| t, r, msg|
	{
	~filter1Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive spectral following of networked control three/slave
	~filterResponder2 = OSCresponder(~networkReceiver0, '/filters2', {| t, r, msg|
	{
	~filter2Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive MFCC of networked control one
	~mfccDataResponder0 = OSCresponder(~networkReceiver0, '/mfccData0', {| t, r, msg|
	{
	~mfccData0Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13], msg[14]];
	}.defer;
	}).add;

// receive MFCC of networked control two
	~mfccDataResponder1 = OSCresponder(~networkReceiver0, '/mfccData1', {| t, r, msg|
	{
	~mfccData1Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13], msg[14]];
	}.defer;
	}).add;

// receive MFCC of networked control three/slave
	~mfccDataResponder2 = OSCresponder(~networkReceiver0, '/mfccData2', {| t, r, msg|
	{
	~mfccData2Reply = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11], msg[12], msg[13]];
	}.defer;
	}).add;

// receive pitch of networked control one
	~pitchResponder0 = OSCresponder(~networkReceiver0, '/pitch0', {| t, r, msg|
	{
	~pitchReply0 = [msg[1], msg[2], msg[3]];
	}.defer;
	}).add;

// receive clock of networked instance
	~clockResponder0 = OSCresponder(~networkReceiver0, '/clock0', {| t, r, msg|
	{
	~clockReply0 = [msg[1], msg[2], msg[3]];
	}.defer;
	}).add;

// receive selected variables of networked instance
	~systemResponder0 = OSCresponder(~networkReceiver0, '/system0', {| t, r, msg|
	{
	~systemReply0 = [msg[1], msg[2], msg[3], msg[4], msg[5], msg[6], msg[7], msg[8], msg[9], msg[10], msg[11]];
	}.defer;
	}).add;

	};

	~filterCutter0 = [0,0,0,0,0,0,0,0,0,0,0,0,0];
	~filterCutter1 = [0,0,0,0,0,0,0,0,0,0,0,0,0];
	~filterCutter2 = [0,0,0,0,0,0,0,0,0,0,0,0,0];

	~filterCutterGUI0 = [0,0,0,0,0,0,0,0,0,0,0,0,0];
	~filterCutterGUI1 = [0,0,0,0,0,0,0,0,0,0,0,0,0];
	~filterCutterGUI2 = [0,0,0,0,0,0,0,0,0,0,0,0,0];
	~visualiserMultiplier = 0;

	~filterTracker0On = 0;
	~filterTracker1On = 0;
	~filterTracker2On = 0;

	~filter0On = 0;
	~filter1On = 0;
	~filter2On = 0;

// collect GUI settings from control busses
	guiUpdateRoutine0 = Task {
	inf.do{
		~gui0Bus0.getn(63, {arg value; {
		~osc0pitch0Message = value[2];
		~pitchMessage0 = value[4].min(2000);
		~pitchMessage1 = value[6].min(2000);
		~tempo0Message0 = value[12];
		~tempo1Message0 = value[13];
		~tempo0Textbox0.string_((~tempo0Message0)*60.round(1)).asString;
		~tempo1Textbox0.string_((~tempo1Message0)*60.round(1)).asString;
		~grainPitch0Message0 = value[24].min(2000);
		freezeVolume0 = value[31];
		freezeVolume1 = value[32];
		freezeVolume2 = value[33];

		~filter0On = value[9];
		~filter1On = value[10];
		~filter2On = value[23];

		~filterTracker0On = value[46];
		~filterTracker1On = value[47];
		~filterTracker2On = value[48];

		if (value[62] >= 0.0001,

		{~visualiserMultiplier = 1;};

		);

		if (value[62] < 0.0001,

		{~visualiserMultiplier = 0;};

		);

		grainsVolume0 = value[34] * ~visualiserMultiplier;
		grainsVolume1 = value[35] * ~visualiserMultiplier;
		grainsVolume2 = value[36] * ~visualiserMultiplier;

// place control bus data in network senders
		~networkReturn0.sendMsg(*(["return0"] ++ [~networkIn0]));
		~networkSender0.sendMsg(*(["pitch0"] ++ [value[4], value[18], ~networkOut0]));
		~networkSender1.sendMsg(*(["pitch0"] ++ [value[4], value[18], ~networkOut0]));
		~networkSender2.sendMsg(*(["pitch0"] ++ [value[4], value[18], ~networkOut0]));
		~networkSender3.sendMsg(*(["pitch0"] ++ [value[4], value[18], ~networkOut0]));
		~networkSender4.sendMsg(*(["pitch0"] ++ [value[4], value[18], ~networkOut0]));
		~networkSender5.sendMsg(*(["pitch0"] ++ [value[4], value[18], ~networkOut0]));
		~networkSender6.sendMsg(*(["pitch0"] ++ [value[4], value[18], ~networkOut0]));
		~networkSender7.sendMsg(*(["pitch0"] ++ [value[4], value[18], ~networkOut0]));
		~networkSender0.sendMsg(*(["mfccData0"] ++ mfccData0 ++ power0));
		~networkSender1.sendMsg(*(["mfccData0"] ++ mfccData0 ++ power0));
		~networkSender2.sendMsg(*(["mfccData0"] ++ mfccData0 ++ power0));
		~networkSender3.sendMsg(*(["mfccData0"] ++ mfccData0 ++ power0));
		~networkSender4.sendMsg(*(["mfccData0"] ++ mfccData0 ++ power0));
		~networkSender5.sendMsg(*(["mfccData0"] ++ mfccData0 ++ power0));
		~networkSender6.sendMsg(*(["mfccData0"] ++ mfccData0 ++ power0));
		~networkSender7.sendMsg(*(["mfccData0"] ++ mfccData0 ++ power0));
		~networkSender0.sendMsg(*(["mfccData1"] ++ mfccData1 ++ power1));
		~networkSender1.sendMsg(*(["mfccData1"] ++ mfccData1 ++ power1));
		~networkSender2.sendMsg(*(["mfccData1"] ++ mfccData1 ++ power1));
		~networkSender3.sendMsg(*(["mfccData1"] ++ mfccData1 ++ power1));
		~networkSender4.sendMsg(*(["mfccData1"] ++ mfccData1 ++ power1));
		~networkSender5.sendMsg(*(["mfccData1"] ++ mfccData1 ++ power1));
		~networkSender6.sendMsg(*(["mfccData1"] ++ mfccData1 ++ power1));
		~networkSender7.sendMsg(*(["mfccData1"] ++ mfccData1 ++ power1));
		~networkSender0.sendMsg(*(["mfccData2"] ++ mfccData2));
		~networkSender1.sendMsg(*(["mfccData2"] ++ mfccData2));
		~networkSender2.sendMsg(*(["mfccData2"] ++ mfccData2));
		~networkSender3.sendMsg(*(["mfccData2"] ++ mfccData2));
		~networkSender4.sendMsg(*(["mfccData2"] ++ mfccData2));
		~networkSender5.sendMsg(*(["mfccData2"] ++ mfccData2));
		~networkSender6.sendMsg(*(["mfccData2"] ++ mfccData2));
		~networkSender7.sendMsg(*(["mfccData2"] ++ mfccData2));
		~networkSender0.sendMsg(*(["clock0"] ++ [syncOut, ~clockOut, ~clockGUI]));
		~networkSender1.sendMsg(*(["clock0"] ++ [syncOut, ~clockOut, ~clockGUI]));
		~networkSender2.sendMsg(*(["clock0"] ++ [syncOut, ~clockOut, ~clockGUI]));
		~networkSender3.sendMsg(*(["clock0"] ++ [syncOut, ~clockOut, ~clockGUI]));
		~networkSender4.sendMsg(*(["clock0"] ++ [syncOut, ~clockOut, ~clockGUI]));
		~networkSender5.sendMsg(*(["clock0"] ++ [syncOut, ~clockOut, ~clockGUI]));
		~networkSender6.sendMsg(*(["clock0"] ++ [syncOut, ~clockOut, ~clockGUI]));
		~networkSender7.sendMsg(*(["clock0"] ++ [syncOut, ~clockOut, ~clockGUI]));
		~networkSender0.sendMsg(*(["system0"] ++ [~networkSampleChange0, ~networkSampleSelector0, ~networkRecord0, ~recordNetworkLength0, ~quickLoadNetworkOn, ~quickLoadNetworkValue, ~networkInputSelector0, ~networkInputSelector1, ~networkInputSelector2, ~networkSwitchOut0, ~networkSyncOut0]));
		~networkSender1.sendMsg(*(["system0"] ++ [~networkSampleChange0, ~networkSampleSelector0, ~networkRecord0, ~recordNetworkLength0, ~quickLoadNetworkOn, ~quickLoadNetworkValue, ~networkInputSelector0, ~networkInputSelector1, ~networkInputSelector2, ~networkSwitchOut0, ~networkSyncOut0]));
		~networkSender2.sendMsg(*(["system0"] ++ [~networkSampleChange0, ~networkSampleSelector0, ~networkRecord0, ~recordNetworkLength0, ~quickLoadNetworkOn, ~quickLoadNetworkValue, ~networkInputSelector0, ~networkInputSelector1, ~networkInputSelector2, ~networkSwitchOut0, ~networkSyncOut0]));
		~networkSender3.sendMsg(*(["system0"] ++ [~networkSampleChange0, ~networkSampleSelector0, ~networkRecord0, ~recordNetworkLength0, ~quickLoadNetworkOn, ~quickLoadNetworkValue, ~networkInputSelector0, ~networkInputSelector1, ~networkInputSelector2, ~networkSwitchOut0, ~networkSyncOut0]));
		~networkSender4.sendMsg(*(["system0"] ++ [~networkSampleChange0, ~networkSampleSelector0, ~networkRecord0, ~recordNetworkLength0, ~quickLoadNetworkOn, ~quickLoadNetworkValue, ~networkInputSelector0, ~networkInputSelector1, ~networkInputSelector2, ~networkSwitchOut0, ~networkSyncOut0]));
		~networkSender5.sendMsg(*(["system0"] ++ [~networkSampleChange0, ~networkSampleSelector0, ~networkRecord0, ~recordNetworkLength0, ~quickLoadNetworkOn, ~quickLoadNetworkValue, ~networkInputSelector0, ~networkInputSelector1, ~networkInputSelector2, ~networkSwitchOut0, ~networkSyncOut0]));
		~networkSender6.sendMsg(*(["system0"] ++ [~networkSampleChange0, ~networkSampleSelector0, ~networkRecord0, ~recordNetworkLength0, ~quickLoadNetworkOn, ~quickLoadNetworkValue, ~networkInputSelector0, ~networkInputSelector1, ~networkInputSelector2, ~networkSwitchOut0, ~networkSyncOut0]));
		~networkSender7.sendMsg(*(["system0"] ++ [~networkSampleChange0, ~networkSampleSelector0, ~networkRecord0, ~recordNetworkLength0, ~quickLoadNetworkOn, ~quickLoadNetworkValue, ~networkInputSelector0, ~networkInputSelector1, ~networkInputSelector2, ~networkSwitchOut0, ~networkSyncOut0]));
		~oscData0Slider0.value_([mfccData0, ~mfccData0Reply[0..12]].at(~networkSelector0));
		~oscData1Slider0.value_([mfccData1, ~mfccData1Reply[0..12]].at(~networkSelector0));
		~powerReturn0 = ([power0, ~mfccData0Reply[13]].at(~networkSelector0));
		~powerReturn1 = ([power1, ~mfccData1Reply[13]].at(~networkSelector0));
		~powerReturn2 = power2;
		~interactInput0 = [~powerReturn0, ~powerReturn1, ~powerReturn2, ~manualInteract0];
		~oscData2Slider0.value_(mfccData2);
		~w7.refresh;
		}.defer});

	//Get MFCC Data0 from control bus
	~mfccBus0.getn(13, {arg value; {mfccData0 = value;}.defer});

	//Get MFCC Data1 from control bus
	~mfccBus1.getn(13, {arg value; {mfccData1 = value;}.defer});

	//Get MFCC Data2 from control bus
	~mfccBus2.getn(13, {arg value; {mfccData2 = value;}.defer});

	//Get Loudness values from control bus
	~powersBus0.getn(3, {arg value; {power0 = value[0]; power1 = value[1]; power2 = value[2];}.defer});

	//Get Envelope0 from control bus
	~envelopeBus0.getn(13, {arg value; {envelope0Data0 = value;}.defer});

	//Get Envelope1 from control bus
	~envelopeBus1.getn(13, {arg value; {envelope1Data0 = value;}.defer});

	//Get Envelope2 from control bus
	~envelopeBus2.getn(13, {arg value; {envelope2Data0 = value;}.defer});

	//Get Onset0 from control bus
	~threshold0Bus0.getn(13, {arg value; {onset0Data0 = value;
		~onsetDataSelector0 = [onset0Data0, onset0Breed0].at(~dataSelector0);}.defer});

	//Get Onset1 from control bus
	~threshold1Bus0.getn(13, {arg value; {onset1Data0 = value;
		~onsetDataSelector1 = [onset1Data0, onset0Breed0].at(~dataSelector1);}.defer});

	//Get duration0 from control bus
	~duration0Bus0.getn(13, {arg value; {duration0Data0 = value;
		~durationDataSelector0 = [duration0Data0, duration0Breed0].at(~dataSelector0);}.defer});

	//Get duration1 from control bus
	~duration1Bus0.getn(13, {arg value; {duration1Data0 = value;
		~durationDataSelector1 = [duration1Data0, duration0Breed0].at(~dataSelector1);}.defer});

	//Get duration2 from control bus
	~duration2Bus0.getn(13, {arg value; {duration2Data0 = value;}.defer});

	//Get pan0 from control bus
	~pan0Bus0.getn(13, {arg value; {pan0Data0 = value;
		~panDataSelector0 = [pan0Data0, pan0Breed0].at(~dataSelector0);}.defer});

	//Get pan1 from control bus
	~pan1Bus0.getn(13, {arg value; {pan1Data0 = value;
		~panDataSelector1 = [pan1Data0, pan0Breed0].at(~dataSelector1);}.defer});

	//Get pan2 from control bus
	~pan2Bus0.getn(13, {arg value; {pan2Data0 = value;}.defer});

	//Get Envelope0 from control bus
	~guiEnvelopeBus0.getn(39, {arg value; {envelopeData0 = value;
		~envelopeDataSelector0 = [envelopeData0, envelopeBreed].at(~dataSelector0);}.defer});

	//Get Envelope1 from control bus
	~guiEnvelopeBus1.getn(39, {arg value; {envelopeData1 = value;
		~envelopeDataSelector1 = [envelopeData1, envelopeBreed].at(~dataSelector1);}.defer});

	//Get Pitch0 from control bus
	~grainPitch0Bus0.getn(13, {arg value; {pitch0Data0 = value;
		~pitchDataSelector0 = [pitch0Data0, pitch0Breed0].at(~dataSelector0);}.defer});

	//Get Pitch1 from control bus
	~grainPitch1Bus0.getn(13, {arg value; {pitch1Data0 = value;
		~pitchDataSelector1 = [pitch1Data0, pitch0Breed0].at(~dataSelector1);}.defer});

	//Get Pitch2 from control bus
	~grainPitch2Bus0.getn(13, {arg value; {pitch2Data0 = value;}.defer});

	//Get Grain Position 0 from control bus
	~grainPositionBus0.getn(13, {arg value; {position0Data0 = value;}.defer});

	//Get Grain Position 1 from control bus
	~grainPositionBus1.getn(13, {arg value; {position1Data0 = value;}.defer});

	//Get Grain Position 2 from control bus
	~grainPositionBus2.getn(13, {arg value; {position2Data0 = value;}.defer});

	//Get Freeze Data 0 from control bus
	~freezeBus0.getn(13, {arg value; {freezeData0 = value;}.defer});

	//Get Freeze Data 1 from control bus
	~freezeBus1.getn(13, {arg value; {freezeData1 = value;}.defer});

	//Get Freeze Data 2 from control bus
	~freezeBus2.getn(13, {arg value; {freezeData2 = value;}.defer});

	//Get Filter Freq Data 0 from control bus
	~filterFreqBus0.getn(13, {arg value; {filterFreqData0 = value;}.defer});

	//Get Filter Freq Data 1 from control bus
	~filterFreqBus1.getn(13, {arg value; {filterFreqData1 = value;}.defer});

	//Get Filter Freq Data 2 from control bus
	~filterFreqBus2.getn(13, {arg value; {filterFreqData2 = value;}.defer});

	//Get buffer position of sample ugens from control bus
	~position0Bus0.getn(3, {arg value; {
											~sampleViewer0.timeCursorPosition = value[0];
											~sampleViewer1.timeCursorPosition = value[1];
											~sampleViewer2.timeCursorPosition = value[2];}.defer});

	//Get tempo values from control buss
	~controlTempoBus0.getn(3, {arg value; {
		~bufferSynth.set(\tempoCompare0, value[0]);
		~bufferSynth.set(\tempoCompare1, value[1]);
		~tempo2Textbox0.string_((value[2])*60.round(1)).asString;
		~interactTempo0 = value[2];
		}.defer});

	//get triggers from control one
				~trigger0Bus0.getn(13, {|vals| {
				~tickButton0[0].value_(~volumeSpec0.map([vals[0].min(1), ~trigger0Reply[0].min(1)].at(~networkSelector0)));
				~tickButton0[1].value_(~volumeSpec0.map([vals[1].min(1), ~trigger0Reply[1].min(1)].at(~networkSelector0)));
				~tickButton0[2].value_(~volumeSpec0.map([vals[2].min(1), ~trigger0Reply[2].min(1)].at(~networkSelector0)));
				~tickButton0[3].value_(~volumeSpec0.map([vals[3].min(1), ~trigger0Reply[3].min(1)].at(~networkSelector0)));
				~tickButton0[4].value_(~volumeSpec0.map([vals[4].min(1), ~trigger0Reply[4].min(1)].at(~networkSelector0)));
				~tickButton0[5].value_(~volumeSpec0.map([vals[5].min(1), ~trigger0Reply[5].min(1)].at(~networkSelector0)));
				~tickButton0[6].value_(~volumeSpec0.map([vals[6].min(1), ~trigger0Reply[6].min(1)].at(~networkSelector0)));
				~tickButton0[7].value_(~volumeSpec0.map([vals[7].min(1), ~trigger0Reply[7].min(1)].at(~networkSelector0)));
				~tickButton0[8].value_(~volumeSpec0.map([vals[8].min(1), ~trigger0Reply[8].min(1)].at(~networkSelector0)));
				~tickButton0[9].value_(~volumeSpec0.map([vals[9].min(1), ~trigger0Reply[9].min(1)].at(~networkSelector0)));
				~tickButton0[10].value_(~volumeSpec0.map([vals[10].min(1), ~trigger0Reply[10].min(1)].at(~networkSelector0)));
				~tickButton0[11].value_(~volumeSpec0.map([vals[11].min(1), ~trigger0Reply[11].min(1)].at(~networkSelector0)));
				~tickButton0[12].value_(~volumeSpec0.map([vals[12].min(1), ~trigger0Reply[12].min(1)].at(~networkSelector0)));
				attack00 = [vals.sum, ~trigger0Reply.sum].at(~networkSelector0);
				triggers0Network = vals;
				~networkSender0.sendMsg(*(["triggers0"] ++ triggers0Network));
				~networkSender1.sendMsg(*(["triggers0"] ++ triggers0Network));
				~networkSender2.sendMsg(*(["triggers0"] ++ triggers0Network));
				~networkSender3.sendMsg(*(["triggers0"] ++ triggers0Network));
				~networkSender4.sendMsg(*(["triggers0"] ++ triggers0Network));
				~networkSender5.sendMsg(*(["triggers0"] ++ triggers0Network));
				~networkSender6.sendMsg(*(["triggers0"] ++ triggers0Network));
				~networkSender7.sendMsg(*(["triggers0"] ++ triggers0Network));

				}.defer});

	//get triggers from control two
			~trigger1Bus0.getn(13, {|vals| {
				~tickButton1[0].value_(~volumeSpec0.map([vals[0], ~trigger1Reply[0].min(1)].at(~networkSelector0)));
				~tickButton1[1].value_(~volumeSpec0.map([vals[1], ~trigger1Reply[1].min(1)].at(~networkSelector0)));
				~tickButton1[2].value_(~volumeSpec0.map([vals[2], ~trigger1Reply[2].min(1)].at(~networkSelector0)));
				~tickButton1[3].value_(~volumeSpec0.map([vals[3], ~trigger1Reply[3].min(1)].at(~networkSelector0)));
				~tickButton1[4].value_(~volumeSpec0.map([vals[4], ~trigger1Reply[4].min(1)].at(~networkSelector0)));
				~tickButton1[5].value_(~volumeSpec0.map([vals[5], ~trigger1Reply[5].min(1)].at(~networkSelector0)));
				~tickButton1[6].value_(~volumeSpec0.map([vals[6], ~trigger1Reply[6].min(1)].at(~networkSelector0)));
				~tickButton1[7].value_(~volumeSpec0.map([vals[7], ~trigger1Reply[7].min(1)].at(~networkSelector0)));
				~tickButton1[8].value_(~volumeSpec0.map([vals[8], ~trigger1Reply[8].min(1)].at(~networkSelector0)));
				~tickButton1[9].value_(~volumeSpec0.map([vals[9], ~trigger1Reply[9].min(1)].at(~networkSelector0)));
				~tickButton1[10].value_(~volumeSpec0.map([vals[10], ~trigger1Reply[10].min(1)].at(~networkSelector0)));
				~tickButton1[11].value_(~volumeSpec0.map([vals[11], ~trigger1Reply[11].min(1)].at(~networkSelector0)));
				~tickButton1[12].value_(~volumeSpec0.map([vals[12], ~trigger1Reply[12].min(1)].at(~networkSelector0)));
				attack01 = [vals.sum, ~trigger1Reply.sum].at(~networkSelector0);
				triggers1Network = vals;
				~networkSender0.sendMsg(*(["triggers1"] ++ triggers1Network));
				~networkSender1.sendMsg(*(["triggers1"] ++ triggers1Network));
				~networkSender2.sendMsg(*(["triggers1"] ++ triggers1Network));
				~networkSender3.sendMsg(*(["triggers1"] ++ triggers1Network));
				~networkSender4.sendMsg(*(["triggers1"] ++ triggers1Network));
				~networkSender5.sendMsg(*(["triggers1"] ++ triggers1Network));
				~networkSender6.sendMsg(*(["triggers1"] ++ triggers1Network));
				~networkSender7.sendMsg(*(["triggers1"] ++ triggers1Network));
				}.defer});

	//get triggers from control three/slave
			~grainGuiTriggerBus0.getn(13, {|vals| {
				~tickButton2[0].value_(~volumeSpec0.map(vals[0].min(1)));
				~tickButton2[1].value_(~volumeSpec0.map(vals[1].min(1)));
				~tickButton2[2].value_(~volumeSpec0.map(vals[2].min(1)));
				~tickButton2[3].value_(~volumeSpec0.map(vals[3].min(1)));
				~tickButton2[4].value_(~volumeSpec0.map(vals[4].min(1)));
				~tickButton2[5].value_(~volumeSpec0.map(vals[5].min(1)));
				~tickButton2[6].value_(~volumeSpec0.map(vals[6].min(1)));
				~tickButton2[7].value_(~volumeSpec0.map(vals[7].min(1)));
				~tickButton2[8].value_(~volumeSpec0.map(vals[8].min(1)));
				~tickButton2[9].value_(~volumeSpec0.map(vals[9].min(1)));
				~tickButton2[10].value_(~volumeSpec0.map(vals[10].min(1)));
				~tickButton2[11].value_(~volumeSpec0.map(vals[11].min(1)));
				~tickButton2[12].value_(~volumeSpec0.map(vals[12].min(1)));
				attack02 = vals.sum;
				grainTriggerNetwork = vals;
				~networkSender0.sendMsg(*(["triggers2"] ++ grainTriggerNetwork));
				~networkSender1.sendMsg(*(["triggers2"] ++ grainTriggerNetwork));
				~networkSender2.sendMsg(*(["triggers2"] ++ grainTriggerNetwork));
				~networkSender3.sendMsg(*(["triggers2"] ++ grainTriggerNetwork));
				~networkSender4.sendMsg(*(["triggers2"] ++ grainTriggerNetwork));
				~networkSender5.sendMsg(*(["triggers2"] ++ grainTriggerNetwork));
				~networkSender6.sendMsg(*(["triggers2"] ++ grainTriggerNetwork));
				~networkSender7.sendMsg(*(["triggers2"] ++ grainTriggerNetwork));
				}.defer});

	//get spectral following from control one
				~filterTracker0.getn(13, {arg value; {
				~filterTrackerSlider0[0].value = [value[0], ~filter0Reply[0]].at(~networkSelector0);
				~filterTrackerSlider0[1].value = [value[1], ~filter0Reply[1]].at(~networkSelector0);
				~filterTrackerSlider0[2].value = [value[2], ~filter0Reply[2]].at(~networkSelector0);
				~filterTrackerSlider0[3].value = [value[3], ~filter0Reply[3]].at(~networkSelector0);
				~filterTrackerSlider0[4].value = [value[4], ~filter0Reply[4]].at(~networkSelector0);
				~filterTrackerSlider0[5].value = [value[5], ~filter0Reply[5]].at(~networkSelector0);
				~filterTrackerSlider0[6].value = [value[6], ~filter0Reply[6]].at(~networkSelector0);
				~filterTrackerSlider0[7].value = [value[7], ~filter0Reply[7]].at(~networkSelector0);
				~filterTrackerSlider0[8].value = [value[8], ~filter0Reply[8]].at(~networkSelector0);
				~filterTrackerSlider0[9].value = [value[9], ~filter0Reply[9]].at(~networkSelector0);
				~filterTrackerSlider0[10].value = [value[10], ~filter0Reply[10]].at(~networkSelector0);
				~filterTrackerSlider0[11].value = [value[11], ~filter0Reply[11]].at(~networkSelector0);
				~filterTrackerSlider0[12].value = [value[12], ~filter0Reply[12]].at(~networkSelector0);
				~filterCutter0 = [value, ~filter0Reply].at(~networkSelector0);
				~mfccDataSelector0 = [value, mfccBreed].at(~dataSelector0);
				~networkSender0.sendMsg(*(["filters0"] ++ value));
				~networkSender1.sendMsg(*(["filters0"] ++ value));
				~networkSender2.sendMsg(*(["filters0"] ++ value));
				~networkSender3.sendMsg(*(["filters0"] ++ value));
				~networkSender4.sendMsg(*(["filters0"] ++ value));
				~networkSender5.sendMsg(*(["filters0"] ++ value));
				~networkSender6.sendMsg(*(["filters0"] ++ value));
				~networkSender7.sendMsg(*(["filters0"] ++ value));

				}.defer});

	//get spectral following from control two
				~filterTracker1.getn(13, {arg value; {
				~filterTrackerSlider1[0].value = [value[0], ~filter1Reply[0]].at(~networkSelector0);
				~filterTrackerSlider1[1].value = [value[1], ~filter1Reply[1]].at(~networkSelector0);
				~filterTrackerSlider1[2].value = [value[2], ~filter1Reply[2]].at(~networkSelector0);
				~filterTrackerSlider1[3].value = [value[3], ~filter1Reply[3]].at(~networkSelector0);
				~filterTrackerSlider1[4].value = [value[4], ~filter1Reply[4]].at(~networkSelector0);
				~filterTrackerSlider1[5].value = [value[5], ~filter1Reply[5]].at(~networkSelector0);
				~filterTrackerSlider1[6].value = [value[6], ~filter1Reply[6]].at(~networkSelector0);
				~filterTrackerSlider1[7].value = [value[7], ~filter1Reply[7]].at(~networkSelector0);
				~filterTrackerSlider1[8].value = [value[8], ~filter1Reply[8]].at(~networkSelector0);
				~filterTrackerSlider1[9].value = [value[9], ~filter1Reply[9]].at(~networkSelector0);
				~filterTrackerSlider1[10].value = [value[10], ~filter1Reply[10]].at(~networkSelector0);
				~filterTrackerSlider1[11].value = [value[11], ~filter1Reply[11]].at(~networkSelector0);
				~filterTrackerSlider1[12].value = [value[12], ~filter1Reply[12]].at(~networkSelector0);
				~filterCutter1 = [value, ~filter1Reply].at(~networkSelector0);
				~mfccDataSelector1 = [value, mfccBreed].at(~dataSelector1);
				~networkSender0.sendMsg(*(["filters1"] ++ value));
				~networkSender1.sendMsg(*(["filters1"] ++ value));
				~networkSender2.sendMsg(*(["filters1"] ++ value));
				~networkSender3.sendMsg(*(["filters1"] ++ value));
				~networkSender4.sendMsg(*(["filters1"] ++ value));
				~networkSender5.sendMsg(*(["filters1"] ++ value));
				~networkSender6.sendMsg(*(["filters1"] ++ value));
				~networkSender7.sendMsg(*(["filters1"] ++ value));
				}.defer});

	//get spectral following from control three/slave
				~filterTracker2.getn(13, {arg value; {
				~filterTrackerSlider2[0].value = value[0];
				~filterTrackerSlider2[1].value = value[1];
				~filterTrackerSlider2[2].value = value[2];
				~filterTrackerSlider2[3].value = value[3];
				~filterTrackerSlider2[4].value = value[4];
				~filterTrackerSlider2[5].value = value[5];
				~filterTrackerSlider2[6].value = value[6];
				~filterTrackerSlider2[7].value = value[7];
				~filterTrackerSlider2[8].value = value[8];
				~filterTrackerSlider2[9].value = value[9];
				~filterTrackerSlider2[10].value = value[10];
				~filterTrackerSlider2[11].value = value[11];
				~filterTrackerSlider2[12].value = value[12];
				~filterCutter2 = value;
				~networkSender0.sendMsg(*(["filters2"] ++ value));
				~networkSender1.sendMsg(*(["filters2"] ++ value));
				~networkSender2.sendMsg(*(["filters2"] ++ value));
				~networkSender3.sendMsg(*(["filters2"] ++ value));
				~networkSender4.sendMsg(*(["filters2"] ++ value));
				~networkSender5.sendMsg(*(["filters2"] ++ value));
				~networkSender6.sendMsg(*(["filters2"] ++ value));
				~networkSender7.sendMsg(*(["filters2"] ++ value));
				}.defer});

				~cpuPerf = s.peakCPU;
				{~performanceText0.string = "Peak CPU: " ++ ~cpuPerf.asInteger.asString ++ "%";}.defer;


	(1/30).wait;
	};
	};

guiUpdateRoutine0.play;

// pitch fix process GUI routine
	~scalerUpdateRoutine0 = Task {
	inf.do{
		~scaleControl0.getn(3, {arg value; {
				scaleMessage0 = value[0];
				scaleMessage1 = value[1];
				scaleMessage2 = value[2];
				~noteView0.string = scaleMessage2.cpsmidi.midiname;
				~noteView1.string = scaleMessage0.cpsmidi.midiname;
				~w5.refresh;
				}.defer});
	(1/30).wait;
	}.defer;
	};

// default values of spectal density
~powerReturn0 = 0;
~powerReturn1 = 0;
~powerReturn2 = 0;
~manualInteract0 = 0;

~w5.front;
~w6.front;
~w7.front;
~w1.front;

// toggle performance setting
~performanceButton0 = Button(~w6, Rect(25, 300, 100, 15));
~performanceButton0.states_([
					["Performance Hi", Color.black.alpha_(0.8),Color.red.alpha_(0.8)],
					["Performance Lo", Color.red.alpha_(0.8),Color.black.alpha_(0.8)],
							]);
~performanceButton0.font_(Font("Monaco", 10));
~performanceButton0.value = 0;
~performanceButton0.action = {arg butt;
	if( butt.value == 0,
	{
	~pan0Synth.free;
	~pan1Synth.free;
	~pan2Synth.free;
	~pan0Synth = Synth(\panner0);
	~pan1Synth = Synth(\panner1);
	~pan2Synth = Synth(\panner2);
	});

	if( butt.value == 1,
	{
	~pan0Synth.free;
	~pan1Synth.free;
	~pan2Synth.free;
	~pan0Synth = Synth(\pannerLo0);
	~pan1Synth = Synth(\pannerLo1);
	~pan2Synth = Synth(\pannerLo2);
	});
	};

// display current cpu value
~performanceText0 = StaticText(~w6, Rect(128, 300, 100, 15));
~performanceText0.string = "Peak CPU: ";
~performanceText0.font_(Font("Monaco", 10));

// set resolution of dynamic scoring
~visualResolutionWidth0 = 960;
~visualResolutionHeight0 = 600;
~borderOn = true;

~visualWindowCheck0 = 0;
~visualSizeDivider0 = 4;
~visualWidth = ~visualResolutionWidth0/~visualSizeDivider0;
~visualHeight = ~visualResolutionHeight0/~visualSizeDivider0;

// toggle size of dynamic scoring window
~visualDividerPopUp0 = PopUpMenu(~w5, Rect(275, 200, 25, 25));
~visualDividerPopUp0.items = ["Mini", "Full Screen"];
~visualDividerPopUp0.action_({arg menu;
	if ( menu.value == 0,
	{

	~visualSizeDivider0 = 4;
	~visualWidth = ~visualResolutionWidth0/~visualSizeDivider0;
	~visualHeight = ~visualResolutionHeight0/~visualSizeDivider0;
	~borderOn = true;

	};
	);
	if ( menu.value == 1,
	{

	~visualSizeDivider0 = 1;
	~visualWidth = ~visualResolutionWidth0/~visualSizeDivider0;
	~visualHeight = ~visualResolutionHeight0/~visualSizeDivider0;
	~borderOn = false;

	};
	);
	});

// toggle dynamic scoring
~visualiserButton0 = Button(~w5, Rect(200, 200, 75, 25));
~visualiserButton0.states_([
					["Visual Off", Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["Visual On", Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);
~visualiserButton0.font_(Font("Monaco", 10));
~visualiserButton0.action = {arg butt;
	if( butt.value == 1,
	{

~visualWindowCheck0 = 1;


// create window for dynamic scoring
~visualiserWindow = Window("Genesis Visualiser", Rect(0, 0, ~visualWidth * 2, ~visualHeight * 2), false, ~borderOn);
~visualiserWindow.view.background = Color.gray;
~visualiserWindow.alwaysOnTop = true;
~visualiserWindow.userCanClose = false;
~visualiserWindow.front;
~visualSwitch0 = Button(~visualiserWindow, Rect(0, 0, ~visualWidth * 2, ~visualHeight * 2));
~visualSlaveSource = StaticText(~visualiserWindow, Rect(0, 890, ~visualWidth * 2 , 100));
~visualSlaveSource.font = Font("Monaco", 50);
~visualSlaveSource.align = \center;
~visualSlaveSource.stringColor = Color.blue;
~visualSwitch0.states_([
					["", Color.white.alpha_(0),Color.white.alpha_(0)],
							]);

~visualSwitch0.action = {~visualiserButton0.valueAction = 0;};

~visualiserWindow.drawFunc = {



//dynamic scoring for granular synthesizers triggered by control one

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
        Pen.width = (duration0Data0[0] * 15);
   		1.do {
			Color.yellow([1, [(filterFreqData0[0]/4000) + 0.5, (~filterCutter0[0]/4000) + 0.5].at(~visualSpectrum0)].at(~visualFilter0), (envelope0Data0[0] * grainsVolume0) * ([1, [1, ~filterCutterGUI0[0]].at(~visualSpectrum0)].at(~visualFilter0))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan0Data0[0], (pitch0Data0[0] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position0Data0[0], position0Data0[0]);
            Pen.stroke;
        };

	};


	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration0Data0[1] * 15);
		1.do {
			Color.yellow([1, [(filterFreqData0[1]/4000) + 0.5, (~filterCutter0[1]/4000) + 0.5].at(~visualSpectrum0)].at(~visualFilter0), (envelope0Data0[1] * grainsVolume0) * ([1, [1, ~filterCutterGUI0[1]].at(~visualSpectrum0)].at(~visualFilter0))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan0Data0[1], (pitch0Data0[1] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position0Data0[1], position0Data0[1]);
            Pen.stroke;
        };

	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration0Data0[2] * 15);
        1.do {
			Color.yellow([1, [(filterFreqData0[2]/4000) + 0.5, (~filterCutter0[2]/4000) + 0.5].at(~visualSpectrum0)].at(~visualFilter0), (envelope0Data0[2] * grainsVolume0) * ([1, [1, ~filterCutterGUI0[2]].at(~visualSpectrum0)].at(~visualFilter0))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan0Data0[2], (pitch0Data0[2] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position0Data0[2], position0Data0[2]);
            Pen.stroke;
        };
	};


	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration0Data0[3] * 15);
        1.do {
			Color.yellow([1, [(filterFreqData0[3]/4000) + 0.5, (~filterCutter0[3]/4000) + 0.5].at(~visualSpectrum0)].at(~visualFilter0), (envelope0Data0[3] * grainsVolume0) * ([1, [1, ~filterCutterGUI0[3]].at(~visualSpectrum0)].at(~visualFilter0))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan0Data0[3], (pitch0Data0[3] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position0Data0[3], position0Data0[3]);
            Pen.stroke;
        };

	};


	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration0Data0[4] * 15);
        1.do {
			Color.yellow([1, [(filterFreqData0[4]/4000) + 0.5, (~filterCutter0[4]/4000) + 0.5].at(~visualSpectrum0)].at(~visualFilter0), (envelope0Data0[4] * grainsVolume0) * ([1, [1, ~filterCutterGUI0[4]].at(~visualSpectrum0)].at(~visualFilter0))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan0Data0[4], (pitch0Data0[4] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position0Data0[4], position0Data0[4]);
            Pen.stroke;
        };

	};


	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration0Data0[5] * 15);
        1.do {
			Color.yellow([1, [(filterFreqData0[5]/4000) + 0.5, (~filterCutter0[5]/4000) + 0.5].at(~visualSpectrum0)].at(~visualFilter0), (envelope0Data0[5] * grainsVolume0) * ([1, [1, ~filterCutterGUI0[5]].at(~visualSpectrum0)].at(~visualFilter0))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan0Data0[5], (pitch0Data0[5] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position0Data0[5], position0Data0[5]);
            Pen.stroke;
        };

	};


	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration0Data0[6] * 15);
        1.do {
			Color.yellow([1, [(filterFreqData0[6]/4000) + 0.5, (~filterCutter0[6]/4000) + 0.5].at(~visualSpectrum0)].at(~visualFilter0), (envelope0Data0[6] * grainsVolume0) * ([1, [1, ~filterCutterGUI0[6]].at(~visualSpectrum0)].at(~visualFilter0))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan0Data0[6], (pitch0Data0[6] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position0Data0[6], position0Data0[6]);
            Pen.stroke;
        };

	};


	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration0Data0[7] * 15);
        1.do {
			Color.yellow([1, [(filterFreqData0[7]/4000) + 0.5, (~filterCutter0[7]/4000) + 0.5].at(~visualSpectrum0)].at(~visualFilter0), (envelope0Data0[7] * grainsVolume0) * ([1, [1, ~filterCutterGUI0[7]].at(~visualSpectrum0)].at(~visualFilter0))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan0Data0[7], (pitch0Data0[7] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position0Data0[7], position0Data0[7]);
            Pen.stroke;
        };

	};


	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration0Data0[8] * 15);
        1.do {
			Color.yellow([1, [(filterFreqData0[8]/4000) + 0.5, (~filterCutter0[8]/4000) + 0.5].at(~visualSpectrum0)].at(~visualFilter0), (envelope0Data0[8] * grainsVolume0) * ([1, [1, ~filterCutterGUI0[8]].at(~visualSpectrum0)].at(~visualFilter0))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan0Data0[8], (pitch0Data0[8] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position0Data0[8], position0Data0[8]);
            Pen.stroke;
        };

	};


	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration0Data0[9] * 15);
		1.do {
			Color.yellow([1, [(filterFreqData0[9]/4000) + 0.5, (~filterCutter0[9]/4000) + 0.5].at(~visualSpectrum0)].at(~visualFilter0), (envelope0Data0[9] * grainsVolume0) * ([1, [1, ~filterCutterGUI0[9]].at(~visualSpectrum0)].at(~visualFilter0))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan0Data0[9], (pitch0Data0[9] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position0Data0[9], position0Data0[9]);
            Pen.stroke;
        };

	};


	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration0Data0[10] * 15);
        1.do {
			Color.yellow([1, [(filterFreqData0[10]/4000) + 0.5, (~filterCutter0[10]/4000) + 0.5].at(~visualSpectrum0)].at(~visualFilter0), (envelope0Data0[10] * grainsVolume0) * ([1, [1, ~filterCutterGUI0[10]].at(~visualSpectrum0)].at(~visualFilter0))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan0Data0[10], (pitch0Data0[10] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position0Data0[10], position0Data0[10]);
            Pen.stroke;
        };

	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration0Data0[11] * 15);
		1.do {
			Color.yellow([1, [(filterFreqData0[11]/4000) + 0.5, (~filterCutter0[11]/4000) + 0.5].at(~visualSpectrum0)].at(~visualFilter0), (envelope0Data0[11] * grainsVolume0) * ([1, [1, ~filterCutterGUI0[11]].at(~visualSpectrum0)].at(~visualFilter0))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan0Data0[11], (pitch0Data0[11] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position0Data0[11], position0Data0[11]);
            Pen.stroke;
        };

	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);

		Pen.width = (duration0Data0[12] * 15);
		1.do {
			Color.yellow([1, [(filterFreqData0[12]/4000) + 0.5, (~filterCutter0[12]/4000) + 0.5].at(~visualSpectrum0)].at(~visualFilter0), (envelope0Data0[12] * grainsVolume0) * ([1, [1, ~filterCutterGUI0[12]].at(~visualSpectrum0)].at(~visualFilter0))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan0Data0[12], (pitch0Data0[12] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position0Data0[12], position0Data0[12]);
            Pen.stroke;
        };

	};


    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.yellow.alpha_((envelope0Data0[0] + freezeData0[0]) * freezeVolume0);
			Pen.addArc((pan0Data0[0] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch0Data0[0]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.yellow.alpha_((envelope0Data0[1] + freezeData0[1]) * freezeVolume0);
			Pen.addArc((pan0Data0[1] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch0Data0[1]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.yellow.alpha_((envelope0Data0[2] + freezeData0[2]) * freezeVolume0);
			Pen.addArc((pan0Data0[2] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch0Data0[2]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.yellow.alpha_((envelope0Data0[3] + freezeData0[3]) * freezeVolume0);
			Pen.addArc((pan0Data0[3] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch0Data0[3]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.yellow.alpha_((envelope0Data0[4] + freezeData0[4]) * freezeVolume0);
			Pen.addArc((pan0Data0[4] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch0Data0[4]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.yellow.alpha_((envelope0Data0[5] + freezeData0[5]) * freezeVolume0);
			Pen.addArc((pan0Data0[5] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch0Data0[5]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.yellow.alpha_((envelope0Data0[6] + freezeData0[6]) * freezeVolume0);
			Pen.addArc((pan0Data0[6] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch0Data0[6]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.yellow.alpha_((envelope0Data0[7] + freezeData0[7]) * freezeVolume0);
			Pen.addArc((pan0Data0[7] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch0Data0[7]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.yellow.alpha_((envelope0Data0[8] + freezeData0[8]) * freezeVolume0);
			Pen.addArc((pan0Data0[8] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch0Data0[8]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.yellow.alpha_((envelope0Data0[9] + freezeData0[9]) * freezeVolume0);
			Pen.addArc((pan0Data0[9] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch0Data0[9]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.yellow.alpha_((envelope0Data0[10] + freezeData0[10]) * freezeVolume0);
			Pen.addArc((pan0Data0[10] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch0Data0[10]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.yellow.alpha_((envelope0Data0[11] + freezeData0[11]) * freezeVolume0);
			Pen.addArc((pan0Data0[11] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch0Data0[11]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.yellow.alpha_((envelope0Data0[12] + freezeData0[12]) * freezeVolume0);
			Pen.addArc((pan0Data0[12] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch0Data0[12]) , pi);
			Pen.perform(\stroke);
        };

	};

//dynamic scoring for granular synthesizers triggered by control two

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration1Data0[0] * 15);
   		1.do {
			Color.red([1, [(filterFreqData1[0]/4000) + 0.5, (~filterCutter1[0]/4000) + 0.5].at(~visualSpectrum1)].at(~visualFilter1), (envelope1Data0[0] * grainsVolume1) * ([1, [1, ~filterCutterGUI1[0]].at(~visualSpectrum1)].at(~visualFilter1))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan1Data0[0], (pitch1Data0[0] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position1Data0[0], position1Data0[0]);
            Pen.stroke;
        };
	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration1Data0[1] * 15);
		1.do {
			Color.red([1, [(filterFreqData1[1]/4000) + 0.5, (~filterCutter1[1]/4000) + 0.5].at(~visualSpectrum1)].at(~visualFilter1), (envelope1Data0[1] * grainsVolume1) * ([1, [1, ~filterCutterGUI1[1]].at(~visualSpectrum1)].at(~visualFilter1))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan1Data0[1], (pitch1Data0[1] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position1Data0[1], position1Data0[1]);
            Pen.stroke;
        };
	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);

		Pen.width = (duration1Data0[2] * 15);
        1.do {
			Color.red([1, [(filterFreqData1[2]/4000) + 0.5, (~filterCutter1[2]/4000) + 0.5].at(~visualSpectrum1)].at(~visualFilter1), (envelope1Data0[2] * grainsVolume1) * ([1, [1, ~filterCutterGUI1[2]].at(~visualSpectrum1)].at(~visualFilter1))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan1Data0[2], (pitch1Data0[2] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position1Data0[2], position1Data0[2]);
            Pen.stroke;
        };
	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration1Data0[3] * 15) / pitch1Data0[3];
        1.do {
			Color.red([1, [(filterFreqData1[3]/4000) + 0.5, (~filterCutter1[3]/4000) + 0.5].at(~visualSpectrum1)].at(~visualFilter1), (envelope1Data0[3] * grainsVolume1) * ([1, [1, ~filterCutterGUI1[3]].at(~visualSpectrum1)].at(~visualFilter1))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan1Data0[3], (pitch1Data0[3] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position1Data0[3], position1Data0[3]);
            Pen.stroke;
        };
	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration1Data0[4] * 15);
        1.do {
			Color.red([1, [(filterFreqData1[4]/4000) + 0.5, (~filterCutter1[4]/4000) + 0.5].at(~visualSpectrum1)].at(~visualFilter1), (envelope1Data0[4] * grainsVolume1) * ([1, [1, ~filterCutterGUI1[4]].at(~visualSpectrum1)].at(~visualFilter1))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan1Data0[4], (pitch1Data0[4] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position1Data0[4], position1Data0[4]);
            Pen.stroke;
        };
	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration1Data0[5] * 15);
        1.do {
			Color.red([1, [(filterFreqData1[5]/4000) + 0.5, (~filterCutter1[5]/4000) + 0.5].at(~visualSpectrum1)].at(~visualFilter1), (envelope1Data0[5] * grainsVolume1) * ([1, [1, ~filterCutterGUI1[5]].at(~visualSpectrum1)].at(~visualFilter1))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan1Data0[5], (pitch1Data0[5] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position1Data0[5], position1Data0[5]);
            Pen.stroke;
        };
	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration1Data0[6] * 15);
        1.do {
			Color.red([1, [(filterFreqData1[6]/4000) + 0.5, (~filterCutter1[6]/4000) + 0.5].at(~visualSpectrum1)].at(~visualFilter1), (envelope1Data0[6] * grainsVolume1) * ([1, [1, ~filterCutterGUI1[6]].at(~visualSpectrum1)].at(~visualFilter1))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan1Data0[6], (pitch1Data0[6] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position1Data0[6], position1Data0[6]);
            Pen.stroke;
        };
	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration1Data0[7] * 15);
        1.do {
			Color.red([1, [(filterFreqData1[7]/4000) + 0.5, (~filterCutter1[7]/4000) + 0.5].at(~visualSpectrum1)].at(~visualFilter1), (envelope1Data0[7] * grainsVolume1) * ([1, [1, ~filterCutterGUI1[7]].at(~visualSpectrum1)].at(~visualFilter1))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan1Data0[7], (pitch1Data0[7] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position1Data0[7], position1Data0[7]);
            Pen.stroke;
        };
	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration1Data0[8] * 15);
        1.do {
			Color.red([1, [(filterFreqData1[8]/4000) + 0.5, (~filterCutter1[8]/4000) + 0.5].at(~visualSpectrum1)].at(~visualFilter1), (envelope1Data0[8] * grainsVolume1) * ([1, [1, ~filterCutterGUI1[8]].at(~visualSpectrum1)].at(~visualFilter1))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan1Data0[8], (pitch1Data0[8] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position1Data0[8], position1Data0[8]);
            Pen.stroke;
        };
	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration1Data0[9] * 15);
		1.do {
			Color.red([1, [(filterFreqData1[9]/4000) + 0.5, (~filterCutter1[9]/4000) + 0.5].at(~visualSpectrum1)].at(~visualFilter1), (envelope1Data0[9] * grainsVolume1) * ([1, [1, ~filterCutterGUI1[9]].at(~visualSpectrum1)].at(~visualFilter1))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan1Data0[9], (pitch1Data0[9] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position1Data0[9], position1Data0[9]);
            Pen.stroke;
        };
	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration1Data0[10] * 15);
        1.do {
			Color.red([1, [(filterFreqData1[10]/4000) + 0.5, (~filterCutter1[10]/4000) + 0.5].at(~visualSpectrum1)].at(~visualFilter1), (envelope1Data0[10] * grainsVolume1) * ([1, [1, ~filterCutterGUI1[10]].at(~visualSpectrum1)].at(~visualFilter1))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan1Data0[10], (pitch1Data0[10] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position1Data0[10], position1Data0[10]);
            Pen.stroke;
        };
	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration1Data0[11] * 15);
		1.do {
			Color.red([1, [(filterFreqData1[11]/4000) + 0.5, (~filterCutter1[11]/4000) + 0.5].at(~visualSpectrum1)].at(~visualFilter1), (envelope1Data0[11] * grainsVolume1) * ([1, [1, ~filterCutterGUI1[11]].at(~visualSpectrum1)].at(~visualFilter1))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan1Data0[11], (pitch1Data0[11] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position1Data0[11], position1Data0[11]);
            Pen.stroke;
        };
 	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration1Data0[12] * 15);
		1.do {
			Color.red([1, [(filterFreqData1[12]/4000) + 0.5, (~filterCutter1[12]/4000) + 0.5].at(~visualSpectrum1)].at(~visualFilter1), (envelope1Data0[12] * grainsVolume1) * ([1, [1, ~filterCutterGUI1[12]].at(~visualSpectrum1)].at(~visualFilter1))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan1Data0[12], (pitch1Data0[12] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position1Data0[12], position1Data0[12]);
            Pen.stroke;
        };
	};

 Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.red.alpha_((envelope1Data0[0] + freezeData1[0]) * freezeVolume1);
			Pen.addArc((pan1Data0[0] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch1Data0[0]) , pi);
			Pen.perform(\stroke);
        };

	};

 Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.red.alpha_((envelope1Data0[1] + freezeData1[1]) * freezeVolume1);
			Pen.addArc((pan1Data0[1] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch1Data0[1]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.red.alpha_((envelope1Data0[2] + freezeData1[2]) * freezeVolume1);
			Pen.addArc((pan1Data0[2] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch1Data0[2]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.red.alpha_((envelope1Data0[3] + freezeData1[3]) * freezeVolume1);
			Pen.addArc((pan1Data0[3] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch1Data0[3]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.red.alpha_((envelope1Data0[4] + freezeData1[4]) * freezeVolume1);
			Pen.addArc((pan1Data0[4] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch1Data0[4]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.red.alpha_((envelope1Data0[5] + freezeData1[5]) * freezeVolume1);
			Pen.addArc((pan1Data0[5] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch1Data0[5]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.red.alpha_((envelope1Data0[6] + freezeData1[6]) * freezeVolume1);
			Pen.addArc((pan1Data0[6] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch1Data0[6]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.red.alpha_((envelope1Data0[7] + freezeData1[7]) * freezeVolume1);
			Pen.addArc((pan1Data0[7] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch1Data0[7]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.red.alpha_((envelope1Data0[8] + freezeData1[8]) * freezeVolume1);
			Pen.addArc((pan1Data0[8] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch1Data0[8]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.red.alpha_((envelope1Data0[9] + freezeData1[9]) * freezeVolume1);
			Pen.addArc((pan1Data0[9] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch1Data0[9]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.red.alpha_((envelope1Data0[10] + freezeData1[10]) * freezeVolume1);
			Pen.addArc((pan1Data0[10] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch1Data0[10]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.red.alpha_((envelope1Data0[11] + freezeData1[11]) * freezeVolume1);
			Pen.addArc((pan1Data0[11] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch1Data0[11]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.red.alpha_((envelope1Data0[12] + freezeData1[12]) * freezeVolume1);
			Pen.addArc((pan1Data0[12] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch1Data0[12]) , pi);
			Pen.perform(\stroke);
        };

	};


//dynamic scoring for granular synthesizers triggered by control three/slave

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration2Data0[0] * 15);
   		1.do {
			Color.blue([1, [(filterFreqData2[0]/4000) + 0.5, (~filterCutter2[0]/4000) + 0.5].at(~visualSpectrum2)].at(~visualFilter2), (envelope2Data0[0] * grainsVolume2) * ([1, [1, ~filterCutterGUI2[0]].at(~visualSpectrum2)].at(~visualFilter2))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan2Data0[0], (pitch2Data0[0] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position2Data0[0], position2Data0[0]);
            Pen.stroke;
        };
	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration2Data0[1] * 15);
		1.do {
			Color.blue([1, [(filterFreqData2[1]/4000) + 0.5, (~filterCutter2[1]/4000) + 0.5].at(~visualSpectrum2)].at(~visualFilter2), (envelope2Data0[1] * grainsVolume2) * ([1, [1, ~filterCutterGUI2[1]].at(~visualSpectrum2)].at(~visualFilter2))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan2Data0[1], (pitch2Data0[1] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position2Data0[1], position2Data0[1]);
            Pen.stroke;
        };
	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration2Data0[2] * 15);
        1.do {
			Color.blue([1, [(filterFreqData2[2]/4000) + 0.5, (~filterCutter2[2]/4000) + 0.5].at(~visualSpectrum2)].at(~visualFilter2), (envelope2Data0[2] * grainsVolume2) * ([1, [1, ~filterCutterGUI2[2]].at(~visualSpectrum2)].at(~visualFilter2))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan2Data0[2], (pitch2Data0[2] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position2Data0[2], position2Data0[2]);
            Pen.stroke;
        };
	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration2Data0[3] * 15);
        1.do {
			Color.blue([1, [(filterFreqData2[3]/4000) + 0.5, (~filterCutter2[3]/4000) + 0.5].at(~visualSpectrum2)].at(~visualFilter2), (envelope2Data0[3] * grainsVolume2) * ([1, [1, ~filterCutterGUI2[3]].at(~visualSpectrum2)].at(~visualFilter2))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan2Data0[3], (pitch2Data0[3] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position2Data0[3], position2Data0[3]);
            Pen.stroke;
        };
	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration2Data0[4] * 15);
        1.do {
			Color.blue([1, [(filterFreqData2[4]/4000) + 0.5, (~filterCutter2[4]/4000) + 0.5].at(~visualSpectrum2)].at(~visualFilter2), (envelope2Data0[4] * grainsVolume2) * ([1, [1, ~filterCutterGUI2[4]].at(~visualSpectrum2)].at(~visualFilter2))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan2Data0[4], (pitch2Data0[4] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position2Data0[4], position2Data0[4]);
            Pen.stroke;
        };
	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration2Data0[5] * 15);
        1.do {
			Color.blue([1, [(filterFreqData2[5]/4000) + 0.5, (~filterCutter2[5]/4000) + 0.5].at(~visualSpectrum2)].at(~visualFilter2), (envelope2Data0[5] * grainsVolume2) * ([1, [1, ~filterCutterGUI2[5]].at(~visualSpectrum2)].at(~visualFilter2))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan2Data0[5], (pitch2Data0[5] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position2Data0[5], position2Data0[5]);
            Pen.stroke;
        };
	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration2Data0[6] * 15);
        1.do {
			Color.blue([1, [(filterFreqData2[6]/4000) + 0.5, (~filterCutter2[6]/4000) + 0.5].at(~visualSpectrum2)].at(~visualFilter2), (envelope2Data0[6] * grainsVolume2) * ([1, [1, ~filterCutterGUI2[6]].at(~visualSpectrum2)].at(~visualFilter2))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan2Data0[6], (pitch2Data0[6] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position2Data0[6], position2Data0[6]);
            Pen.stroke;
        };
	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration2Data0[7] * 15);
        1.do {
			Color.blue([1, [(filterFreqData2[7]/4000) + 0.5, (~filterCutter2[7]/4000) + 0.5].at(~visualSpectrum2)].at(~visualFilter2), (envelope2Data0[7] * grainsVolume2) * ([1, [1, ~filterCutterGUI2[7]].at(~visualSpectrum2)].at(~visualFilter2))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan2Data0[7], (pitch2Data0[7] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position2Data0[7], position2Data0[7]);
            Pen.stroke;
        };
	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration2Data0[8] * 15);
        1.do {
			Color.blue([1, [(filterFreqData2[8]/4000) + 0.5, (~filterCutter2[8]/4000) + 0.5].at(~visualSpectrum2)].at(~visualFilter2), (envelope2Data0[8] * grainsVolume2) * ([1, [1, ~filterCutterGUI2[8]].at(~visualSpectrum2)].at(~visualFilter2))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan2Data0[8], (pitch2Data0[8] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position2Data0[8], position2Data0[8]);
            Pen.stroke;
        };
	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration2Data0[9] * 15);
		1.do {
			Color.blue([1, [(filterFreqData2[9]/4000) + 0.5, (~filterCutter2[9]/4000) + 0.5].at(~visualSpectrum2)].at(~visualFilter2), (envelope2Data0[9] * grainsVolume2) * ([1, [1, ~filterCutterGUI2[9]].at(~visualSpectrum2)].at(~visualFilter2))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan2Data0[9], (pitch2Data0[9] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position2Data0[9], position2Data0[9]);
            Pen.stroke;
        };
	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration2Data0[10] * 15);
        1.do {
			Color.blue([1, [(filterFreqData2[10]/4000) + 0.5, (~filterCutter2[10]/4000) + 0.5].at(~visualSpectrum2)].at(~visualFilter2), (envelope2Data0[10] * grainsVolume2) * ([1, [1, ~filterCutterGUI2[10]].at(~visualSpectrum2)].at(~visualFilter2))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan2Data0[10], (pitch2Data0[10] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position2Data0[10], position2Data0[10]);
            Pen.stroke;
        };
	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration2Data0[11] * 15);
		1.do {
			Color.blue([1, [(filterFreqData2[11]/4000) + 0.5, (~filterCutter2[11]/4000) + 0.5].at(~visualSpectrum2)].at(~visualFilter2), (envelope2Data0[11] * grainsVolume2) * ([1, [1, ~filterCutterGUI2[11]].at(~visualSpectrum2)].at(~visualFilter2))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan2Data0[11], (pitch2Data0[11] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position2Data0[11], position2Data0[11]);
            Pen.stroke;
        };
	};

	Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (duration2Data0[12] * 15);
		1.do {
			Color.blue([1, [(filterFreqData2[12]/4000) + 0.5, (~filterCutter2[12]/4000) + 0.5].at(~visualSpectrum2)].at(~visualFilter2), (envelope2Data0[12] * grainsVolume2) * ([1, [1, ~filterCutterGUI2[12]].at(~visualSpectrum2)].at(~visualFilter2))).setStroke;
            Pen.moveTo(Point((~visualWidth) * pan2Data0[12], (pitch2Data0[12] * (~visualHeight/4)) * -1));
            Pen.lineTo(Point(0, 0));
			Pen.skew(position2Data0[12], position2Data0[12]);
            Pen.stroke;
        };

    };

 Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.blue.alpha_((envelope2Data0[0] + freezeData2[0]) * freezeVolume2);
			Pen.addArc((pan2Data0[0] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch2Data0[0]) , pi);
			Pen.perform(\stroke);
        };

	};

 Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.blue.alpha_((envelope2Data0[1] + freezeData2[1]) * freezeVolume2);
			Pen.addArc((pan2Data0[1] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch2Data0[1]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.blue.alpha_((envelope2Data0[2] + freezeData2[2]) * freezeVolume2);
			Pen.addArc((pan2Data0[2] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch2Data0[2]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.blue.alpha_((envelope2Data0[3] + freezeData2[3]) * freezeVolume2);
			Pen.addArc((pan2Data0[3] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch2Data0[3]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.blue.alpha_((envelope2Data0[4] + freezeData2[4]) * freezeVolume2);
			Pen.addArc((pan2Data0[4] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch2Data0[4]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.blue.alpha_((envelope2Data0[5] + freezeData2[5]) * freezeVolume2);
			Pen.addArc((pan2Data0[5] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch2Data0[5]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.blue.alpha_((envelope2Data0[6] + freezeData2[6]) * freezeVolume2);
			Pen.addArc((pan2Data0[6] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch2Data0[6]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.blue.alpha_((envelope2Data0[7] + freezeData2[7]) * freezeVolume2);
			Pen.addArc((pan2Data0[7] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch2Data0[7]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.blue.alpha_((envelope2Data0[8] + freezeData2[8]) * freezeVolume2);
			Pen.addArc((pan2Data0[8] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch2Data0[8]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.blue.alpha_((envelope2Data0[9] + freezeData2[9]) * freezeVolume2);
			Pen.addArc((pan2Data0[9] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch2Data0[9]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.blue.alpha_((envelope2Data0[10] + freezeData2[10]) * freezeVolume2);
			Pen.addArc((pan2Data0[10] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch2Data0[10]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.blue.alpha_((envelope2Data0[11] + freezeData2[11]) * freezeVolume2);
			Pen.addArc((pan2Data0[11] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch2Data0[11]) , pi);
			Pen.perform(\stroke);
        };

	};

    Pen.use {

		Pen.translate(~visualWidth, ~visualHeight);
		Pen.width = (2);
   		1.do {
			Pen.color = Color.blue.alpha_((envelope2Data0[12] + freezeData2[12]) * freezeVolume2);
			Pen.addArc((pan2Data0[12] * ~visualWidth)@(0), 25/~visualSizeDivider0, 2pi * (pitch2Data0[12]) , pi);
			Pen.perform(\stroke);
        };

	};


};

// close sample viewer windows while dynamic scoring is exectued
	~visualRoutine = Task {
	inf.do{

	{~visualiserWindow.refresh;}.defer;

	(1/30).wait;

	}.defer;
	};

//	if(~visualSizeDivider0 == 1,
//	{
//
//    ~sampleWindow0.visible = false;
//    ~sampleWindow1.visible = false;
//    ~sampleWindow2.visible = false;
//	},
//
//	{
//	~sampleWindow0.visible = true;
//	~sampleWindow1.visible = true;
//	~sampleWindow2.visible = true;
//	});

	~visualRoutine.reset;
	~visualRoutine.play;

	},

	{

	~visualWindowCheck0 = 0;

//    ~sampleWindow0.visible = true;
//    ~sampleWindow1.visible = true;
//    ~sampleWindow2.visible = true;

	~visualRoutine.stop;
	~visualiserWindow.close;

	});};

// start default routines
~envelopeRoutine0.play;
~envelopeRoutine1.play;
~networkCheckRoutine0.play;
~networkCheckRoutine1.play;

// assign variables to synthdefs
~inputSynth = Synth(\input);
~bufferSynth = Synth(\buffer);
~fxSynth = Synth(\fx);
~interactSynth = Synth(\interact);
~amplitudeSynth = Synth(\amplitude);
~granularMacroSynth0 = Synth(\macroGranulator0);
~granularMacroSynth1 = Synth(\macroGranulator1);
~granularMacroSynth2 = Synth(\macroGranulator2);
~pan0Synth = Synth(\panner0);
~pan1Synth = Synth(\panner1);
~pan2Synth = Synth(\panner2);
~analysisSynth = Synth(\analysis);
~trackerSynth0 = Synth(\tracker0);
~trackerSynth1 = Synth(\tracker1);
~trackerSynth2 = Synth(\tracker2);
~decimateSynth0 = Synth(\decimate0);
~decimateSynth1 = Synth(\decimate1);
~decimateSynth2 = Synth(\decimate2);
~envelopeSynth = Synth(\envelope);

// quit programme using cmdperiod function. Removes all current buffers and busses aswell as clearing the GUI
CmdPeriod.doOnce({
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " !!!FORCED STOP. QUIT AND RESTART GENESIS!!! ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	guiUpdateRoutine0.stop;
	~networkUpdate0.stop;
	~envelopeRoutine0.stop;
	~envelopeRoutine1.stop;
	~generativeRoutine.stop;
	~filterCutterRoutine.stop;
	~systemNetworkUpdate0.stop;
	~networkCheckRoutine0.stop;
	~networkCheckRoutine1.stop;
   	~clockTask.stop;
	~clockTaskHundreths.stop;
	~clockSyncTask.stop;
	~compositionRoutine1.stop;
	~compositionRoutine2.stop;
	~compositionRoutine3.stop;
	~interactRoutine0.stop;
	~interactRoutine1.stop;
	~interactCounter0.stop;
	~waitCounter0.stop;
    ~w1.close;
//    ~sampleWindow0.close;
//    ~sampleWindow1.close;
//    ~sampleWindow2.close;
    ~w2.close;
    ~saveText.close;
    ~saveText.background = Color.gray.alpha_(1);
	~saveText.front;

    if(~outWindowCheck0 >= 1,
    {
    ~w4.close;
    });

    if(~inWindowCheck0 >= 1,
    {
    ~w0.close;
    });

    if(~interactWindowOn == 1,
    {
    ~interactWindow0.close;
    });

	if( ~visualWindowCheck0 == 1,
	{
	~visualiserWindow.close;
	};);

	~w5.close;
	~w6.close;
	~w7.close;
	~w8.close;
	~loadWindow.close;
	~gui0Bus0.free;
	~mfccBus0.free;
	~mfccBus1.free;
	~mfccBus2.free;
	~trigger0Bus0.free;
	~trigger1Bus0.free;
	~threshold0Bus0.free;
	~threshold1Bus0.free;
	~position0Bus0.free;
	~grainGuiTriggerBus0.free;
	~envelopeBus0.free;
	~envelopeBus1.free;
	~envelopeBus2.free;
	~grainPositionBus0.free;
	~grainPositionBus1.free;
	~grainPositionBus2.free;
	~freezeBus0.free;
	~freezeBus1.free;
	~freezeBus2.free;
	~filterFreqBus0.free;
	~filterFreqBus1.free;
	~filterFreqBus2.free;
	~controlTempoBus0.free;
	~onset0Bus0.free;
	~onset1Bus0.free;
	~onset2Bus0.free;
	~duration0Bus0.free;
	~duration1Bus0.free;
	~duration2Bus0.free;
	~pan0Bus0.free;
	~pan1Bus0.free;
	~pan2Bus0.free;
	~guiEnvelopeBus0.free;
	~guiEnvelopeBus1.free;
	~grainPitch0Bus0.free;
	~grainPitch1Bus0.free;
	~grainPitch2Bus0.free;
	~scaleControl0.free;
	~filterTracker0.free;
	~filterTracker1.free;
	~filterTracker2.free;
	~powersBus0.free;

	~bufferBus0.free;
	~bufferBus1.free;
	~bufferBus2.free;
	~synthBus0.free;
	~synthBus1.free;
	~synthBus2.free;
	~soundInputBus0.free;
	~soundInputBus1.free;
	~fxBus0.free;
	~tempo0Bus0.free;
	~osc0Bus0.free;
	~osc1Bus0.free;
	~osc2Bus0.free;
	~grain0Bus0.free;
	~grain1Bus0.free;
	~grain2Bus0.free;
	~scaleBusOut0.free;
	~scaleSend0.free;
	~triggerOut0.free;
	~triggerOut1.free;
	~triggerOut2.free;

	~fftBuffer0.free;
	~fftBuffer1.free;
	~fftBuffer2.free;
	~mfccBuffer0.free;
	~mfccBuffer1.free;
	~mfccBuffer2.free;
	~powerBuffer0.free;
	~powerBuffer1.free;
	~powerBuffer2.free;
	~inputBuffer.free;
	~recordBuffer0.free;
	~interactBuffer0.free;
	~pitchBuffer0.free;
	~warpBuffer0.free;
	~warpBuffer1.free;
	~warpBuffer2.free;
	~randRoutine0.stop;
	~randSynth0.free;

	b.free;
	c.free;
	d.free;

	~osc0OnsetBuffer0.free;
	~osc1OnsetBuffer0.free;
	~feedback0OnsetBuffer0.free;
	~scaleBuffer.free;

	~ccResponders.remove;
	~triggerResponder0.remove;
	~triggerResponder1.remove;
	~triggerResponder2.remove;
	~filterResponder0.remove;
	~filterResponder1.remove;
	~filterResponder2.remove;
	~mfccDataResponder0.remove;
	~mfccDataResponder1.remove;
	~mfccDataResponder2.remove;
	~pitchResponder0.remove;
	~clockResponder0.remove;
	~networkResponder0.remove;

	~inputSynth.free;
	~bufferSynth.free;
	~fxSynth.free;
	~amplitudeSynth.free;
	~granularMacroSynth0.free;
	~granularMacroSynth1.free;
	~granularMacroSynth2.free;
	~pan0Synth.free;
	~pan1Synth.free;
	~pan2Synth.free;
	~analysisSynth.free;
	~trackerSynth0.free;
	~trackerSynth1.free;
	~trackerSynth2.free;
	~decimateSynth0.free;
	~decimateSynth1.free;
	~decimateSynth2.free;
	~envelopeSynth.free;
	~pitchTrackerSynth.free;
	Server.freeAll;
	Server.quitAll;
	Server.killAll;


});

}.defer;

1.0.wait;

// limiter process to avoid clipping if spectral following is executed for granular synthesizers trigger by control one

{

//random sample selector
	~randButton2 = Button(~w7, Rect((1920/3.25)+1280, 0, (1920/3)/20, 15));
	~randButton2.font_(Font("Monaco", 9));
	~randButton2.states_([
					["Rand",Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["Rand",Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~randButton2.action = {arg butt;

	if((butt.value == 1) && (~randSampleArray0 != ["", "", ""]),

	{

	~randomSampleRoutine = Routine.new({
    inf.do({ arg i;

	~randSampleSelector0 = ~randSampleArray0.wchoose([0.7, 0.2, 0.1]);
	{
	~inputSwitch2.valueAction = 0;
	~loopChoose2.valueAction = 1;
	b.free;
	~samplePath2 = ~randSampleSelector0;
	b.allocRead(~samplePath2.asString);
	~sampleFile2.openRead(~samplePath2.asString);
	~sampleViewer2.soundfile = ~sampleFile2;
	~sampleViewer2.read(0, ~sampleFile2.numFrames);
	~sampleViewer2.refresh;
	~bnumFrames = ~sampleFile2.numFrames;
	~samplePathButton2.states_([[~samplePath2.asString, Color.white, Color.blue.alpha_(0.8)]]);
	~bufferSynth.set(\start2, 0, \end2, ~sampleFile2.numFrames, \mate3Trigger, 1);
	~start = 0;
	~length = ~sampleFile2.numFrames;
	~child.add(1);
	}.defer;

	([1, 0.5, 1.5, 2, 1.25].choose).wait;

    });
	});

	~randomSampleRoutine.reset;
	~randomSampleRoutine.play;


	}
	);

	if(butt.value == 0,

	{

	~randomSampleRoutine.stop;

	});

	};


// random sample allocator
	~randSampleButton0 = PopUpMenu(~w7, Rect((1920/3.25)+1280, 15, (1920/3)/20, 15));
	~randSampleButton0.items = ["0", "1", "2"];
	~randSampleButton0.value = -1;

	~randSampleArray0 = ["", "", ""];

	~randSampleButton0.action = {arg menu;

	if(menu.value == 0,

	{
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0, i;
				~randSampleArray0[0] = path0;
				~randSampleButton0.items = ~randSampleArray0;

			})
		});
	}
	);

	if(menu.value == 1,

	{
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0, i;
				~randSampleArray0[1] = path0;
				~randSampleButton0.items = ~randSampleArray0;
			})
		});
	}
	);

	if(menu.value == 2,

	{
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0, i;
				~randSampleArray0[2] = path0;
				~randSampleButton0.items = ~randSampleArray0;
			})
		});
	}
	);

	};

~filterCutterRoutine = Routine.new({
	inf.do({ arg i;

	if((~filterTracker0On >= 1) && (~filter0On >= 1),

	{

	if ( (~filterCutter0[0] >4000) || (~filterCutter0[0] <20),
	{~granularMacroSynth0.set(\amplitude0, 0); {~filterTrackerSlider0[0].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[0] = 0;},
	{~granularMacroSynth0.set(\amplitude0, 0.5); {~filterTrackerSlider0[0].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[0] = 1;}
	);
	if ( (~filterCutter0[1] >4000) || (~filterCutter0[1] <20),
	{~granularMacroSynth0.set(\amplitude1, 0); {~filterTrackerSlider0[1].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[1] = 0;},
	{~granularMacroSynth0.set(\amplitude1, 0.5); {~filterTrackerSlider0[1].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[1] = 1;}
	);
	if ( (~filterCutter0[2] >4000) || (~filterCutter0[2] <20),
	{~granularMacroSynth0.set(\amplitude2, 0); {~filterTrackerSlider0[2].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[2] = 0;},
	{~granularMacroSynth0.set(\amplitude2, 0.5); {~filterTrackerSlider0[2].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[2] = 1;}
	);
	if ( (~filterCutter0[3] >4000) || (~filterCutter0[3] <20),
	{~granularMacroSynth0.set(\amplitude3, 0); {~filterTrackerSlider0[3].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[3] = 0;},
	{~granularMacroSynth0.set(\amplitude3, 0.5); {~filterTrackerSlider0[3].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[3] = 1;}
	);
	if ( (~filterCutter0[4] >4000) || (~filterCutter0[4] <20),
	{~granularMacroSynth0.set(\amplitude4, 0); {~filterTrackerSlider0[4].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[4] = 0;},
	{~granularMacroSynth0.set(\amplitude4, 0.5); {~filterTrackerSlider0[4].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[4] = 1;}
	);
	if ( (~filterCutter0[5] >4000) || (~filterCutter0[5] <20),
	{~granularMacroSynth0.set(\amplitude5, 0); {~filterTrackerSlider0[5].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[5] = 0;},
	{~granularMacroSynth0.set(\amplitude5, 0.5); {~filterTrackerSlider0[5].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[5] = 1;}
	);
	if ( (~filterCutter0[6] >4000) || (~filterCutter0[6] <20),
	{~granularMacroSynth0.set(\amplitude6, 0); {~filterTrackerSlider0[6].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[6] = 0;},
	{~granularMacroSynth0.set(\amplitude6, 0.5); {~filterTrackerSlider0[6].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[6] = 1;}
	);
	if ( (~filterCutter0[7] >4000) || (~filterCutter0[7] <20),
	{~granularMacroSynth0.set(\amplitude7, 0); {~filterTrackerSlider0[7].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[7] = 0;},
	{~granularMacroSynth0.set(\amplitude7, 0.5); {~filterTrackerSlider0[7].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[7] = 1;}
	);
	if ( (~filterCutter0[8] >4000) || (~filterCutter0[8] <20),
	{~granularMacroSynth0.set(\amplitude8, 0); {~filterTrackerSlider0[8].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[8] = 0;},
	{~granularMacroSynth0.set(\amplitude8, 0.5); {~filterTrackerSlider0[8].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[8] = 1;}
	);
	if ( (~filterCutter0[9] >4000) || (~filterCutter0[9] <20),
	{~granularMacroSynth0.set(\amplitude9, 0); {~filterTrackerSlider0[9].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[9] = 0;},
	{~granularMacroSynth0.set(\amplitude9, 0.5); {~filterTrackerSlider0[9].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[9] = 1;}
	);
	if ( (~filterCutter0[10] >4000) || (~filterCutter0[10] <20),
	{~granularMacroSynth0.set(\amplitude10, 0); {~filterTrackerSlider0[10].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[10] = 0;},
	{~granularMacroSynth0.set(\amplitude10, 0.5); {~filterTrackerSlider0[10].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[10] = 1;}
	);
	if ( (~filterCutter0[11] >4000) || (~filterCutter0[11] <20),
	{~granularMacroSynth0.set(\amplitude11, 0); {~filterTrackerSlider0[11].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[11] = 0;},
	{~granularMacroSynth0.set(\amplitude11, 0.5); {~filterTrackerSlider0[11].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[11] = 1;}
	);
	if ( (~filterCutter0[12] >4000) || (~filterCutter0[12] <20),
	{~granularMacroSynth0.set(\amplitude12, 0); {~filterTrackerSlider0[12].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[12] = 0;},
	{~granularMacroSynth0.set(\amplitude12, 0.5); {~filterTrackerSlider0[12].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[12] = 1;}
	);

	},

	{
	~granularMacroSynth0.set(\amplitude0, 0.5); {~filterTrackerSlider0[0].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[0] = 1;
	~granularMacroSynth0.set(\amplitude1, 0.5); {~filterTrackerSlider0[1].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[1] = 1;
	~granularMacroSynth0.set(\amplitude2, 0.5); {~filterTrackerSlider0[2].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[2] = 1;
	~granularMacroSynth0.set(\amplitude3, 0.5); {~filterTrackerSlider0[3].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[3] = 1;
	~granularMacroSynth0.set(\amplitude4, 0.5); {~filterTrackerSlider0[4].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[4] = 1;
	~granularMacroSynth0.set(\amplitude5, 0.5); {~filterTrackerSlider0[5].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[5] = 1;
	~granularMacroSynth0.set(\amplitude6, 0.5); {~filterTrackerSlider0[6].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[6] = 1;
	~granularMacroSynth0.set(\amplitude7, 0.5); {~filterTrackerSlider0[7].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[7] = 1;
	~granularMacroSynth0.set(\amplitude8, 0.5); {~filterTrackerSlider0[8].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[8] = 1;
	~granularMacroSynth0.set(\amplitude9, 0.5); {~filterTrackerSlider0[9].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[9] = 1;
	~granularMacroSynth0.set(\amplitude10, 0.5); {~filterTrackerSlider0[10].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[10] = 1;
	~granularMacroSynth0.set(\amplitude11, 0.5); {~filterTrackerSlider0[11].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[11] = 1;
	~granularMacroSynth0.set(\amplitude12, 0.5); {~filterTrackerSlider0[12].setColors(Color.grey,Color.white.alpha_(0), Color.yellow.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.yellow,nil, Color.yellow.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI0[12] = 1;
	};

	);

// limiter process to avoid clipping if spectral following is executed for granular synthesizers trigger by control two

	if((~filterTracker1On >= 1) && (~filter1On >= 1),

	{

	if ( (~filterCutter1[0] >4000) || (~filterCutter1[0] <20),
	{~granularMacroSynth1.set(\amplitude0, 0); {~filterTrackerSlider1[0].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[0] = 0;},
	{~granularMacroSynth1.set(\amplitude0, 0.5); {~filterTrackerSlider1[0].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[0] = 1;}
	);
	if ( (~filterCutter1[1] >4000) || (~filterCutter1[1] <20),
	{~granularMacroSynth1.set(\amplitude1, 0); {~filterTrackerSlider1[1].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[1] = 0;},
	{~granularMacroSynth1.set(\amplitude1, 0.5); {~filterTrackerSlider1[1].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[1] = 1;}
	);
	if ( (~filterCutter1[2] >4000) || (~filterCutter1[2] <20),
	{~granularMacroSynth1.set(\amplitude2, 0); {~filterTrackerSlider1[2].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[2] = 0;},
	{~granularMacroSynth1.set(\amplitude2, 0.5); {~filterTrackerSlider1[2].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[2] = 1;}
	);
	if ( (~filterCutter1[3] >4000) || (~filterCutter1[3] <20),
	{~granularMacroSynth1.set(\amplitude3, 0); {~filterTrackerSlider1[3].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[3] = 0;},
	{~granularMacroSynth1.set(\amplitude3, 0.5); {~filterTrackerSlider1[3].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[3] = 1;}
	);
	if ( (~filterCutter1[4] >4000) || (~filterCutter1[4] <20),
	{~granularMacroSynth1.set(\amplitude4, 0); {~filterTrackerSlider1[4].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[4] = 0;},
	{~granularMacroSynth1.set(\amplitude4, 0.5); {~filterTrackerSlider1[4].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[4] = 1;}
	);
	if ( (~filterCutter1[5] >4000) || (~filterCutter1[5] <20),
	{~granularMacroSynth1.set(\amplitude5, 0); {~filterTrackerSlider1[5].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[5] = 0;},
	{~granularMacroSynth1.set(\amplitude5, 0.5); {~filterTrackerSlider1[5].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[5] = 1;}
	);
	if ( (~filterCutter1[6] >4000) || (~filterCutter1[6] <20),
	{~granularMacroSynth1.set(\amplitude6, 0); {~filterTrackerSlider1[6].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[6] = 0;},
	{~granularMacroSynth1.set(\amplitude6, 0.5); {~filterTrackerSlider1[6].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[6] = 1;}
	);
	if ( (~filterCutter1[7] >4000) || (~filterCutter1[7] <20),
	{~granularMacroSynth1.set(\amplitude7, 0); {~filterTrackerSlider1[7].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[7] = 0;},
	{~granularMacroSynth1.set(\amplitude7, 0.5); {~filterTrackerSlider1[7].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[7] = 1;}
	);
	if ( (~filterCutter1[8] >4000) || (~filterCutter1[8] <20),
	{~granularMacroSynth1.set(\amplitude8, 0); {~filterTrackerSlider1[8].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[8] = 0;},
	{~granularMacroSynth1.set(\amplitude8, 0.5); {~filterTrackerSlider1[8].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[8] = 1;}
	);
	if ( (~filterCutter1[9] >4000) || (~filterCutter1[9] <20),
	{~granularMacroSynth1.set(\amplitude9, 0); {~filterTrackerSlider1[9].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[9] = 0;},
	{~granularMacroSynth1.set(\amplitude9, 0.5); {~filterTrackerSlider1[9].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[9] = 1;}
	);
	if ( (~filterCutter1[10] >4000) || (~filterCutter1[10] <20),
	{~granularMacroSynth1.set(\amplitude10, 0); {~filterTrackerSlider1[10].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[10] = 0;},
	{~granularMacroSynth1.set(\amplitude10, 0.5); {~filterTrackerSlider1[10].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[10] = 1;}
	);
	if ( (~filterCutter1[11] >4000) || (~filterCutter1[11] <20),
	{~granularMacroSynth1.set(\amplitude11, 0); {~filterTrackerSlider1[11].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[11] = 0;},
	{~granularMacroSynth1.set(\amplitude11, 0.5); {~filterTrackerSlider1[11].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[11] = 1;}
	);
	if ( (~filterCutter1[12] >4000) || (~filterCutter1[12] <20),
	{~granularMacroSynth1.set(\amplitude12, 0); {~filterTrackerSlider1[12].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[12] = 0;},
	{~granularMacroSynth1.set(\amplitude12, 0.5); {~filterTrackerSlider1[12].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[12] = 1;}
	);
	},

	{
	~granularMacroSynth1.set(\amplitude0, 0.5); {~filterTrackerSlider1[0].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[0] = 1;
	~granularMacroSynth1.set(\amplitude1, 0.5); {~filterTrackerSlider1[1].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[1] = 1;
	~granularMacroSynth1.set(\amplitude2, 0.5); {~filterTrackerSlider1[2].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[2] = 1;
	~granularMacroSynth1.set(\amplitude3, 0.5); {~filterTrackerSlider1[3].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[3] = 1;
	~granularMacroSynth1.set(\amplitude4, 0.5); {~filterTrackerSlider1[4].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[4] = 1;
	~granularMacroSynth1.set(\amplitude5, 0.5); {~filterTrackerSlider1[5].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[5] = 1;
	~granularMacroSynth1.set(\amplitude6, 0.5); {~filterTrackerSlider1[6].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[6] = 1;
	~granularMacroSynth1.set(\amplitude7, 0.5); {~filterTrackerSlider1[7].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[7] = 1;
	~granularMacroSynth1.set(\amplitude8, 0.5); {~filterTrackerSlider1[8].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[8] = 1;
	~granularMacroSynth1.set(\amplitude9, 0.5); {~filterTrackerSlider1[9].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[9] = 1;
	~granularMacroSynth1.set(\amplitude10, 0.5); {~filterTrackerSlider1[10].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[10] = 1;
	~granularMacroSynth1.set(\amplitude11, 0.5); {~filterTrackerSlider1[11].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[11] = 1;
	~granularMacroSynth1.set(\amplitude12, 0.5); {~filterTrackerSlider1[12].setColors(Color.grey,Color.white.alpha_(0), Color.red.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.red,nil, Color.red.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI1[12] = 1;
	};

	);

// limiter process to avoid clipping if spectral following is executed for granular synthesizers trigger by control three/slave
	if((~filterTracker2On >= 1) && (~filter2On >= 1),

	{

	if ( (~filterCutter2[0] >4000) || (~filterCutter2[0] <20),
	{~granularMacroSynth2.set(\amplitude0, 0); {~filterTrackerSlider2[0].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[0] = 0;},
	{~granularMacroSynth2.set(\amplitude0, 0.5); {~filterTrackerSlider2[0].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[0] = 1;}
	);
	if ( (~filterCutter2[1] >4000) || (~filterCutter2[1] <20),
	{~granularMacroSynth2.set(\amplitude1, 0); {~filterTrackerSlider2[1].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[1] = 0;},
	{~granularMacroSynth2.set(\amplitude1, 0.5); {~filterTrackerSlider2[1].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[1] = 1;}
	);
	if ( (~filterCutter2[2] >4000) || (~filterCutter2[2] <20),
	{~granularMacroSynth2.set(\amplitude2, 0); {~filterTrackerSlider2[2].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[2] = 0;},
	{~granularMacroSynth2.set(\amplitude2, 0.5); {~filterTrackerSlider2[2].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[2] = 1;}
	);
	if ( (~filterCutter2[3] >4000) || (~filterCutter2[3] <20),
	{~granularMacroSynth2.set(\amplitude3, 0); {~filterTrackerSlider2[3].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[3] = 0;},
	{~granularMacroSynth2.set(\amplitude3, 0.5); {~filterTrackerSlider2[3].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[3] = 1;}
	);
	if ( (~filterCutter2[4] >4000) || (~filterCutter2[4] <20),
	{~granularMacroSynth2.set(\amplitude4, 0); {~filterTrackerSlider2[4].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[4] = 0;},
	{~granularMacroSynth2.set(\amplitude4, 0.5); {~filterTrackerSlider2[4].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[4] = 1;}
	);
	if ( (~filterCutter2[5] >4000) || (~filterCutter2[5] <20),
	{~granularMacroSynth2.set(\amplitude5, 0); {~filterTrackerSlider2[5].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[5] = 0;},
	{~granularMacroSynth2.set(\amplitude5, 0.5); {~filterTrackerSlider2[5].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[5] = 1;}
	);
	if ( (~filterCutter2[6] >4000) || (~filterCutter2[6] <20),
	{~granularMacroSynth2.set(\amplitude6, 0); {~filterTrackerSlider2[6].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[6] = 0;},
	{~granularMacroSynth2.set(\amplitude6, 0.5); {~filterTrackerSlider2[6].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[6] = 1;}
	);
	if ( (~filterCutter2[7] >4000) || (~filterCutter2[7] <20),
	{~granularMacroSynth2.set(\amplitude7, 0); {~filterTrackerSlider2[7].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[7] = 0;},
	{~granularMacroSynth2.set(\amplitude7, 0.5); {~filterTrackerSlider2[7].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[7] = 1;}
	);
	if ( (~filterCutter2[8] >4000) || (~filterCutter2[8] <20),
	{~granularMacroSynth2.set(\amplitude8, 0); {~filterTrackerSlider2[8].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[8] = 0;},
	{~granularMacroSynth2.set(\amplitude8, 0.5); {~filterTrackerSlider2[8].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[8] = 1;}
	);
	if ( (~filterCutter2[9] >4000) || (~filterCutter2[9] <20),
	{~granularMacroSynth2.set(\amplitude9, 0); {~filterTrackerSlider2[9].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[9] = 0;},
	{~granularMacroSynth2.set(\amplitude9, 0.5); {~filterTrackerSlider2[9].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[9] = 1;}
	);
	if ( (~filterCutter2[10] >4000) || (~filterCutter2[10] <20),
	{~granularMacroSynth2.set(\amplitude10, 0); {~filterTrackerSlider2[10].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[10] = 0;},
	{~granularMacroSynth2.set(\amplitude10, 0.5); {~filterTrackerSlider2[10].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[10] = 1;}
	);
	if ( (~filterCutter2[11] >4000) || (~filterCutter2[11] <20),
	{~granularMacroSynth2.set(\amplitude11, 0); {~filterTrackerSlider2[11].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[11] = 0;},
	{~granularMacroSynth2.set(\amplitude11, 0.5); {~filterTrackerSlider2[11].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[11] = 1;}
	);
	if ( (~filterCutter2[12] >4000) || (~filterCutter2[12] <20),
	{~granularMacroSynth2.set(\amplitude12, 0); {~filterTrackerSlider2[12].setColors(Color.grey,Color.white.alpha_(0), Color.white.alpha_(0) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[12] = 0;},
	{~granularMacroSynth2.set(\amplitude12, 0.5); {~filterTrackerSlider2[12].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5) ,Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[12] = 1;}
	);
	},

	{
	~granularMacroSynth2.set(\amplitude0, 0.5); {~filterTrackerSlider2[0].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[0] = 1;
	~granularMacroSynth2.set(\amplitude1, 0.5); {~filterTrackerSlider2[1].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[1] = 1;
	~granularMacroSynth2.set(\amplitude2, 0.5); {~filterTrackerSlider2[2].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[2] = 1;
	~granularMacroSynth2.set(\amplitude3, 0.5); {~filterTrackerSlider2[3].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[3] = 1;
	~granularMacroSynth2.set(\amplitude4, 0.5); {~filterTrackerSlider2[4].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[4] = 1;
	~granularMacroSynth2.set(\amplitude5, 0.5); {~filterTrackerSlider2[5].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[5] = 1;
	~granularMacroSynth2.set(\amplitude6, 0.5); {~filterTrackerSlider2[6].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[6] = 1;
	~granularMacroSynth2.set(\amplitude7, 0.5); {~filterTrackerSlider2[7].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[7] = 1;
	~granularMacroSynth2.set(\amplitude8, 0.5); {~filterTrackerSlider2[8].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[8] = 1;
	~granularMacroSynth2.set(\amplitude9, 0.5); {~filterTrackerSlider2[9].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[9] = 1;
	~granularMacroSynth2.set(\amplitude10, 0.5); {~filterTrackerSlider2[10].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[10] = 1;
	~granularMacroSynth2.set(\amplitude11, 0.5); {~filterTrackerSlider2[11].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[11] = 1;
	~granularMacroSynth2.set(\amplitude12, 0.5); {~filterTrackerSlider2[12].setColors(Color.grey,Color.white.alpha_(0), Color.blue.alpha_(0.5),Color.grey,Color.white.alpha_(0), Color.blue,nil, Color.blue.alpha_(0.8), Color.white.alpha_(0));}.defer; ~filterCutterGUI2[12] = 1;
	};
	);



// trigger process for GUI displaying Loudness of inputs
	if (  ~powerReturn0 >= 1,
	{~bufferSynth.set(\mfccReturn0, 1.5); {~triggerButtonOn0.value = 1}.defer},
	{~bufferSynth.set(\mfccReturn0, 0); {~triggerButtonOn0.value = 0}.defer}
	);
	if (  ~powerReturn1 >= 1,
	{~bufferSynth.set(\mfccReturn1, 1.5); {~triggerButtonOn1.value = 1}.defer},
	{~bufferSynth.set(\mfccReturn1, 0); {~triggerButtonOn1.value = 0}.defer}
	);
	if (  ~powerReturn2 >= 1,
	{~bufferSynth.set(\mfccReturn2, 1.5); {~triggerButtonOn2.value = 1}.defer},
	{~bufferSynth.set(\mfccReturn2, 0); {~triggerButtonOn2.value = 0}.defer}
	);

		(1/30).wait;
	});
	});

~filterCutterRoutine.play;

// action of Slider controlling level of control one
~osc0LevelSlider0.action = {|ez|
							~bufferSynth.set(\osc0Level0, ez.value);
							~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " osc0Level0 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~osc0LevelSlider0.valueAction = " ++ ~osc0LevelSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling level of control two
~osc1LevelSlider0.action = {|ez|
							~bufferSynth.set(\osc1Level0, ez.value);
							~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " osc0Level1 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~osc1LevelSlider0.valueAction = " ++ ~osc1LevelSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling level of control three/slave
~osc2LevelSlider0.action = {|ez|
							~bufferSynth.set(\osc2Level0, ez.value);
							~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " osc0Level2 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~osc2LevelSlider0.valueAction = " ++ ~osc2LevelSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling decimator of control one
~samplerateSlider0.action = {|ez|
							~bufferSynth.set(\sampleRate0, ez.value);
							~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " sampleRate0 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~samplerateSlider0.valueAction = " ++ ~samplerateSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling decimator of control two
~samplerateSlider1.action = {|ez|
							~bufferSynth.set(\sampleRate1, ez.value);
							~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " sampleRate1 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~samplerateSlider1.valueAction = " ++ ~samplerateSlider1.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling decimator of control three/slave
~samplerateSlider2.action = {|ez|
							~bufferSynth.set(\sampleRate2, ez.value);
							~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " sampleRate2 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~samplerateSlider2.valueAction = " ++ ~samplerateSlider2.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling pitch of sample UGens of control one
~osc0PitchSlider0.action = {|ez|
							~bufferSynth.set(\grainPitcher0, ez.value);
							~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " osc0Pitch0 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~osc0PitchSlider0.valueAction = " ++ ~osc0PitchSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling pitch of sample UGens of control two
~osc1PitchSlider0.action = {|ez|
							~bufferSynth.set(\grainPitcher1, ez.value);
							~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " osc0Pitch1 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~osc1PitchSlider0.valueAction = " ++ ~osc1PitchSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling pitch of control three/slave
~osc2PitchSlider0.action = {|ez|
							~bufferSynth.set(\grainPitcher2, ez.value);
							~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " osc0Pitch2 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~osc2PitchSlider0.valueAction = " ++ ~osc2PitchSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling grain length of sample UGens of control one
~grainLengthSlider0 .action = {|ez|
							~bufferSynth.set(\grainLength0, ez.value);
							~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainLength0 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~grainLengthSlider0.valueAction = " ++ ~grainLengthSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling grain length of sample UGens of control two
~grainLengthSlider1.action = {|ez|
							~bufferSynth.set(\grainLength1, ez.value);
							~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainLength1 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~grainLengthSlider1.valueAction = " ++ ~grainLengthSlider1.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling grain length of sample UGens of control three/slave
~grainLengthSlider2.action = {|ez|
							~bufferSynth.set(\grainLength2, ez.value);
							~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainLength2 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~grainLengthSlider2.valueAction = " ++ ~grainLengthSlider2.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling time stretch of sample UGens of control one
~osc0StretchSlider0.action = {|ez|
							~bufferSynth.set(\timeStretcher0, ez.value);
							~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " timeStretcher0 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~osc0StretchSlider0.valueAction = " ++ ~osc0StretchSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling time stretch of sample UGens of control two
~osc1StretchSlider0.action = {|ez|
							~bufferSynth.set(\timeStretcher1, ez.value);
							~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " timeStretcher1 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~osc1StretchSlider0.valueAction = " ++ ~osc1StretchSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling time stretch of sample UGens of control three/slave
~osc2StretchSlider0.action = {|ez|
							~bufferSynth.set(\timeStretcher2, ez.value);
							~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " timeStretcher2 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~osc2StretchSlider0.valueAction = " ++ ~osc2StretchSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling dry level in output mix
~dryLevelSlider0.action = {|ez|
							~bufferSynth.set(\dryLevel0, ez.value);
							~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " dryLevel0 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~dryLevelSlider0.valueAction = " ++ ~dryLevelSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling  level in overall output mix
~mainOutSlider0.action = {|ez|
							~bufferSynth.set(\mainOutLevel0, ez.value);
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " mainOutLevel0 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~mainOutSlider0.valueAction = " ++ ~mainOutSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling fx level in output mix
~fxLevelSlider0.action = {|ez|
							~bufferSynth.set(\fxLevel0, ez.value);
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " fxLevel0 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~fxLevelSlider0.valueAction = " ++ ~fxLevelSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling level of granular synthesizers triggered by control one in output mix
~grainLevel0Slider.action = {|ez|
							~bufferSynth.set(\grainLevel0, ez.value);
							~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainsLevel0 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~grainLevel0Slider.valueAction = " ++ ~grainLevel0Slider.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling level of filtered granular synthesizers triggered by control one in output mix
~filterSlider0.action = {|ez|
							~bufferSynth.set(\filterLevel0, ez.value);
							~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " filterLevel0 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~filterSlider0.valueAction = " ++ ~filterSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling level of granular synthesizers triggered by control two in output mix
~grainLevel1Slider.action = {|ez|
							~bufferSynth.set(\grainLevel1, ez.value);
							~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainsLevel1 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~grainLevel1Slider.valueAction = " ++ ~grainLevel1Slider.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling level of filtered granular synthesizers triggered by control two in output mix
~filterSlider1.action = {|ez|
							~bufferSynth.set(\filterLevel1, ez.value);
							~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " filterLevel1 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~filterSlider1.valueAction = " ++ ~filterSlider1.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling level of granular synthesizers triggered by control three/slave in output mix
~grainLevel2Slider.action = {|ez|
							~bufferSynth.set(\grainLevel2, ez.value);
							~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainsLevel2 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~grainLevel2Slider.valueAction = " ++ ~grainLevel2Slider.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling level of filtered granular synthesizers triggered by control three/slave in output mix
~filterSlider2.action = {|ez|
							~bufferSynth.set(\filterLevel2, ez.value);
							~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " filterLevel2 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~filterSlider2.valueAction = " ++ ~filterSlider2.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling input level
~micLevelSlider0.action = {|ez|
							~bufferSynth.set(\inputLevel0, ez.value);
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " inputLevel0 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~micLevelSlider0.valueAction = " ++ ~micLevelSlider0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling averaging of control one values
~trackingUpdateSlider1.action = {|ez|
							~bufferSynth.set(\meanUpdate1, ez.value);
							~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " meanUpdate1 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~trackingUpdateSlider1.valueAction = " ++ ~trackingUpdateSlider1.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling averaging of control two values
~trackingUpdateSlider2.action = {|ez|
							~bufferSynth.set.set(\meanUpdate2, ez.value);
							~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " meanUpdate2 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~trackingUpdateSlider2.valueAction = " ++ ~trackingUpdateSlider2.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling averaging of control three/slave values
~trackingUpdateSlider3.action = {|ez|
							~bufferSynth.set.set(\meanUpdate3, ez.value);
							~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " meanUpdate3 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~trackingUpdateSlider3.valueAction = " ++ ~trackingUpdateSlider3.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling base value of spectral following process for granular synthesizers triggered by control one
~filterAdjuster0.action = {|ez|
							~bufferSynth.set.set(\adjuster0, ez.value);
							~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " adjuster0 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~filterAdjuster0.valueAction = " ++ ~filterAdjuster0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling base value of spectral following process for granular synthesizers triggered by control two
~filterAdjuster1.action = {|ez|
							~bufferSynth.set.set(\adjuster1, ez.value);
							~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " adjuster1 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~filterAdjuster1.valueAction = " ++ ~filterAdjuster1.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling base value of spectral following process for granular synthesizers triggered by control three/slave
~filterAdjuster2.action = {|ez|
							~bufferSynth.set.set(\adjuster2, ez.value);
							~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " adjuster2 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~filterAdjuster2.valueAction = " ++ ~filterAdjuster2.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of Slider controlling multiplier of envelope following process
~envelopeAdjuster0.action = {|ez|
							~bufferSynth.set.set(\attackMultiplier0, ez.value);
							~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.string_(" \n\n " ++ ~clockOut ++ " attackMultiplier0 = " ++ ez.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
							~textEditor.selectLine(~textEditor.string.size);
							~saveText.string_(" \n\n " " if(
							~clockGUI == " ++ ~clockGUI ++  "," ++
							"{{ ~envelopeAdjuster0.valueAction = " ++ ~envelopeAdjuster0.value.asString ++  " }.defer;}); ",
							(~saveText.string.size), (~saveText.string.size));
							~saveText.selectLine(~saveText.string.size);
							};

// action of button for toggle of filters for granular synthesizers triggered by control one
~filterOn0.action = {arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\filtersOn0, 0);
	~visualFilter0 = 0;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " filtersOn0 Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~filterOn0.valueAction = " ++ ~filterOn0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);},
	{~bufferSynth.set(\filtersOn0, 1);
	~visualFilter0 = 1;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " filtersOn0 On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~filterOn0.valueAction = " ++ ~filterOn0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);	}
	)
	};

// action of button for toggle of filters for granular synthesizers triggered by control two
~filterOn1.action = {arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\filtersOn1, 0);
		~visualFilter1 = 0;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " filtersOn1 Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~filterOn1.valueAction = " ++ ~filterOn1.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);},
	{~bufferSynth.set(\filtersOn1, 1);
		~visualFilter1 = 1;
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " filtersOn1 On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~filterOn1.valueAction = " ++ ~filterOn1.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);}
	)
	};

// action of button for toggle of filters for granular synthesizers triggered by control three/slave
~filterOn2.action = {arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\filtersOn2, 0);
		~visualFilter2 = 0;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " filtersOn2 Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~filterOn2.valueAction = " ++ ~filterOn2.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);},
	{~bufferSynth.set(\filtersOn2, 1);
		~visualFilter2 = 1;
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " filtersOn2 On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~filterOn2.valueAction = " ++ ~filterOn2.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);}
	)
	};

// action of button for toggle of spectral following for granular synthesizers triggered by control one
~onsetChooser0.action = {arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\filterTrackingOn0, 0);
	~visualSpectrum0 = 0;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " spectrum0 Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~onsetChooser0.valueAction = " ++ ~onsetChooser0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);	},
	{~bufferSynth.set(\filterTrackingOn0, 1);
	~visualSpectrum0 = 1;
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " spectrum0 On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~onsetChooser0.valueAction = " ++ ~onsetChooser0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);		}
	)
	};

// action of button for toggle of spectral following for granular synthesizers triggered by control two
~onsetChooser1.action = {arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\filterTrackingOn1, 0);
	~visualSpectrum1 = 0;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " spectrum1 Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~onsetChooser1.valueAction = " ++ ~onsetChooser1.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);	},
	{~bufferSynth.set(\filterTrackingOn1, 1);
	~visualSpectrum1 = 1;
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " spectrum1 On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~onsetChooser1.valueAction = " ++ ~onsetChooser1.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);		}
	)
	};

// action of button for toggle of spectral following for granular synthesizers triggered by control three/slave
~onsetChooser2.action = {arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\filterTrackingOn2, 0);
	~visualSpectrum2 = 0;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " spectrum2 Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~onsetChooser2.valueAction = " ++ ~onsetChooser2.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);			},
	{~bufferSynth.set(\filterTrackingOn2, 1);
	~visualSpectrum2 = 1;
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " spectrum2 On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~onsetChooser2.valueAction = " ++ ~onsetChooser2.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);}
	)
	};

// action of button for toggle of pitch following
~pitchTrackButton0.action = {arg butt;
	if ( butt.value == 0,
	{~granularMacroSynth0.set(\pitchTrackOn, 0); ~granularMacroSynth1.set(\pitchTrackOn, 0); ~granularMacroSynth2.set(\pitchTrackOn, 0); {~osc2PitchSlider0.valueAction_(1);}.defer;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " pitchTrack Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~pitchTrackButton0.valueAction = " ++ ~pitchTrackButton0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);			},
	{~granularMacroSynth0.set(\pitchTrackOn, 1); ~granularMacroSynth1.set(\pitchTrackOn, 1);  ~granularMacroSynth2.set(\pitchTrackOn, 1);{~osc2PitchSlider0.valueAction_(1);}.defer;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " pitchTrack On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~pitchTrackButton0.valueAction = " ++ ~pitchTrackButton0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);			}
	)
	};

// action of button for toggle of pitch following divider
~pitchFixedButton0.action = {arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\fixedChooser, 0);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " pitchFixed Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~pitchFixedButton0.valueAction = " ++ ~pitchFixedButton0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);},
	{~bufferSynth.set(\fixedChooser, 1);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " pitchFixed On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~pitchFixedButton0.valueAction = " ++ ~pitchFixedButton0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);}
	)
	};

// action of button for toggle of trigger for control one
~triggerButton0.action = {arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\midiIn0, 0);
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Trigger0 Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~triggerButton0.valueAction = " ++ ~triggerButton0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);			},
	{~bufferSynth.set(\midiIn0, 1);
	~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Trigger0 On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~triggerButton0.valueAction = " ++ ~triggerButton0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);			}
	)
	};

// action of button for toggle of trigger for control two
~triggerButton1.action = {arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\midiIn1, 0);
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Trigger1 Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~triggerButton1.valueAction = " ++ ~triggerButton1.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);				},
	{~bufferSynth.set(\midiIn1, 1);
	~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Trigger1 On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~triggerButton1.valueAction = " ++ ~triggerButton1.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);				}
	)
	};

// action of button for toggle of trigger for control three/slave
~triggerButton2.action = {arg butt;
	if ( butt.value == 0,
	{~bufferSynth.set(\midiIn2, 0);
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Trigger2 Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~triggerButton2.valueAction = " ++ ~triggerButton2.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);				},
	{~bufferSynth.set(\midiIn2, 1);
	~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Trigger2 On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~triggerButton2.valueAction = " ++ ~triggerButton2.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);				}
	)
	};

// set GUI to QT
	GUI.qt;
// create window for MultiSliders
	~w8 = Window("Grains Controller", Rect(0, 316, 1920, 370), false, false, scroll: true);
	~w8.background = Color.gray;
	~w8.userCanClose = false;

// set text for granular synthesizer parameters
	~attackText0[0] = StaticText(~w8, Rect(((1920/3)/4)*2 + 10, 92, 120, 120));
	~attackText0[0].string_("attack 0");
	~attackText0[0].stringColor_(Color.white);
	~attackText0[0].font_(Font("Monaco", 18));
	~attackText0[1] = StaticText(~w8, Rect(((1920/3)/4)*2 + 10, 150, 120, 120));
	~attackText0[1].string_("release 0");
	~attackText0[1].stringColor_(Color.white);
	~attackText0[1].font_(Font("Monaco", 18));
	~attackText0[2] = StaticText(~w8, Rect(((1920/3)/4)*6 + 10, 92, 120, 120));
	~attackText0[2].string_("attack 1");
	~attackText0[2].stringColor_(Color.white);
	~attackText0[2].font_(Font("Monaco", 18));
	~attackText0[3] = StaticText(~w8, Rect(((1920/3)/4)*6 + 10, 150, 120, 120));
	~attackText0[3].string_("release 1");
	~attackText0[3].stringColor_(Color.white);
	~attackText0[3].font_(Font("Monaco", 18));
	~attackText0[11] = StaticText(~w8, Rect(((1920/3)/4)*2 + 10, 0, 120, 120));
	~attackText0[11].string_("amplitude 0");
	~attackText0[11].stringColor_(Color.white);
	~attackText0[11].font_(Font("Monaco", 18));
	~attackText0[4] = StaticText(~w8, Rect(((1920/3)/4)*6 + 10, 0, 120, 120));
	~attackText0[4].string_("amplitude 1");
	~attackText0[4].stringColor_(Color.white);
	~attackText0[4].font_(Font("Monaco", 18));
	~attackText0[5] = StaticText(~w8, Rect(10, 240, 120, 123));
	~attackText0[5].string_("duration 0");
	~attackText0[5].stringColor_(Color.white);
	~attackText0[5].font_(Font("Monaco", 18));
	~attackText0[6] = StaticText(~w8, Rect(((1920/3)/4)*4 + 10, 246, 120, 120));
	~attackText0[6].string_("duration 1");
	~attackText0[6].stringColor_(Color.white);
	~attackText0[6].font_(Font("Monaco", 18));
	~attackText0[7] = StaticText(~w8, Rect((((1920/3)/4)*10 + 10), 0, 120, 120));
	~attackText0[7].string_("amplitude 2");
	~attackText0[7].stringColor_(Color.white);
	~attackText0[7].font_(Font("Monaco", 18));
	~attackText0[28] = StaticText(~w8, Rect((((1920/3)/4)*10 + 10), 92, 120, 120));
	~attackText0[28].string_("attack 2");
	~attackText0[28].stringColor_(Color.white);
	~attackText0[28].font_(Font("Monaco", 18));
	~attackText0[29] = StaticText(~w8, Rect((((1920/3)/4)*10 + 10), 150, 100, 120));
	~attackText0[29].string_("release 2");
	~attackText0[29].stringColor_(Color.white);
	~attackText0[29].font_(Font("Monaco", 18));
	~attackText0[8] = StaticText(~w8, Rect(((1920/3)/4)*8 + 10, 246, 120, 120));
	~attackText0[8].string_("duration 2");
	~attackText0[8].stringColor_(Color.white);
	~attackText0[8].font_(Font("Monaco", 18));
	~attackText0[9] = StaticText(~w8, Rect(10, 123, 120, 120));
	~attackText0[9].string_("threshold 0");
	~attackText0[9].stringColor_(Color.white);
	~attackText0[9].font_(Font("Monaco", 18));
	~attackText0[10] = StaticText(~w8, Rect(((1920/3)/4)*4 + 10, 123, 120, 120));
	~attackText0[10].string_("threshold 1");
	~attackText0[10].stringColor_(Color.white);
	~attackText0[10].font_(Font("Monaco", 18));
	~attackText0[12] = StaticText(~w8, Rect(((1920/3)/4)*8 + 10, 123, 120, 120));
	~attackText0[12].string_("threshold 2");
	~attackText0[12].stringColor_(Color.white);
	~attackText0[12].font_(Font("Monaco", 18));
	~attackText0[13] = StaticText(~w8, Rect(((1920/3)/4)*2 + 10, 246, 120, 120));
	~attackText0[13].string_("rate 0");
	~attackText0[13].stringColor_(Color.white);
	~attackText0[13].font_(Font("Monaco", 18));
	~attackText0[14] = StaticText(~w8, Rect(((1920/3)/4)*6 + 10, 246, 120, 120));
	~attackText0[14].string_("rate 1");
	~attackText0[14].stringColor_(Color.white);
	~attackText0[14].font_(Font("Monaco", 18));
	~attackText0[15] = StaticText(~w8, Rect(((1920/3)/4)*10 + 10, 246, 120, 120));
	~attackText0[15].string_("rate 2");
	~attackText0[15].stringColor_(Color.white);
	~attackText0[15].font_(Font("Monaco", 18));
	~attackText0[16] = StaticText(~w8, Rect(10, 0, 120, 120));
	~attackText0[16].string_("filter 0");
	~attackText0[16].stringColor_(Color.white);
	~attackText0[16].font_(Font("Monaco", 18));
	~attackText0[17] = StaticText(~w8, Rect(((1920/3)/4)*4 + 10, 0, 120, 120));
	~attackText0[17].string_("filter 1");
	~attackText0[17].stringColor_(Color.white);
	~attackText0[17].font_(Font("Monaco", 18));
	~attackText0[18] = StaticText(~w8, Rect(((1920/3)/4)*8 + 10, 0, 120, 120));
	~attackText0[18].string_("filter 2");
	~attackText0[18].stringColor_(Color.white);
	~attackText0[18].font_(Font("Monaco", 18));

// create multislider for attack of granular synthesizers triggered by control one
	~grainAttack0Slider = MultiSliderView(~w8, Rect(((1920/3)/4)*2, 123, 1920/6, 60));
	~grainAttack0Slider.value_(Array.fill(13, {arg i; 0.1;}));
	~grainAttack0Slider.fillColor_(Color.yellow.alpha_(0.8));
	~grainAttack0Slider.strokeColor_(Color.yellow.alpha_(0.8));
	~grainAttack0Slider.background_(Color.gray.alpha_(0));
	~grainAttack0Slider.editable_(true);
	~grainAttack0Slider.elasticMode_(1);
	~grainAttack0Slider.thumbSize_(7);
	~grainAttack0Slider.drawLines_(true);
	~grainAttack0Slider.action = {arg q;
								~envelopeSynth.set("grain0Attack"++(q.index), ~attackSpec0.map(q.value.at(q.index)););
								~granularMacroSynth0.set("grain0Attack"++(q.index), ~attackSpec0.map(q.value.at(q.index)););
							   ~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainAttack0 " ++ ~attackSpec0.map(q.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~grainAttack0Slider.valueAction = " ++ ~grainAttack0Slider.value.asString ++  ";
		~grainAttack0Array0 = Array.fill(13, {arg i;
		~envelopeSynth.set(\"grain0Attack\" ++ i.asString, ~attackSpec0.map(~grainAttack0Slider.value[i.value]))});}.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	};

// create multislider for release of granular synthesizers triggered by control one
	~grainRelease0Slider = MultiSliderView(~w8, Rect(((1920/3)/4)*2, 123+60, 1920/6, 60));
	~grainRelease0Slider.value_(Array.fill(13, {arg i; 0.1;}));
	~grainRelease0Slider.fillColor_(Color.yellow.alpha_(0.8));
	~grainRelease0Slider.strokeColor_(Color.yellow.alpha_(0.8));
	~grainRelease0Slider.background_(Color.gray.alpha_(0));
	~grainRelease0Slider.editable_(true);
	~grainRelease0Slider.elasticMode_(1);
	~grainRelease0Slider.thumbSize_(7);
	~grainRelease0Slider.drawLines_(true);
	~grainRelease0Slider.action = {arg xb;
								~envelopeSynth.set("grain0Release"++(xb.index), ~attackSpec0.map(xb.value.at(xb.index)););
								~granularMacroSynth0.set("grain0Release"++(xb.index), ~attackSpec0.map(xb.value.at(xb.index)););
							   ~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainRelease0 " ++ ~attackSpec0.map(xb.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~grainRelease0Slider.valueAction = " ++ ~grainRelease0Slider.value.asString ++  ";
		~grainRelease0Array0 = Array.fill(13, {arg i;
		~envelopeSynth.set(\"grain0Release\" ++ i.asString, ~attackSpec0.map(~grainRelease0Slider.value[i.value]))});}.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

// create multislider for amplitude of granular synthesizers triggered by control one
	~grainAmplitude0Slider = MultiSliderView(~w8, Rect(((1920/3)/4)*2, 0, 1920/6, 120));
	~grainAmplitude0Slider.value_(Array.fill(13, {arg i; 0;}));
	~grainAmplitude0Slider.fillColor_(Color.yellow.alpha_(0.8));
	~grainAmplitude0Slider.strokeColor_(Color.yellow.alpha_(0.8));
	~grainAmplitude0Slider.background_(Color.gray.alpha_(0));
	~grainAmplitude0Slider.editable_(true);
	~grainAmplitude0Slider.elasticMode_(1);
	~grainAmplitude0Slider.thumbSize_(7);
	~grainAmplitude0Slider.drawLines_(true);
	~grainAmplitude0Slider.action = {arg xb;
								~envelopeSynth.set(
								"grain0Amplitude"++(xb.index), ~volumeSpec0.map(xb.value.at(xb.index));
								);
								~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainAmplitude0 " ++ ~volumeSpec0.map(xb.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~grainAmplitude0Slider.valueAction = " ++ ~grainAmplitude0Slider.value.asString ++  ";
		~grainAmplitude0Array0 = Array.fill(13, {arg i;
		~envelopeSynth.set(\"grain0Amplitude\" ++ i.asString, ~volumeSpec0.map(~grainAmplitude0Slider.value[i.value]))});}.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

// create multislider for attack of granular synthesizers triggered by control two
	~grainAttack1Slider = MultiSliderView(~w8, Rect(((1920/3)/4)*6, 123, 1920/6, 60));
	~grainAttack1Slider.value_(Array.fill(13, {arg i; 0.1;}));
	~grainAttack1Slider.fillColor_(Color.red.alpha_(0.8));
	~grainAttack1Slider.strokeColor_(Color.red.alpha_(0.8));
	~grainAttack1Slider.background_(Color.gray.alpha_(0));
	~grainAttack1Slider.editable_(true);
	~grainAttack1Slider.elasticMode_(1);
	~grainAttack1Slider.thumbSize_(7);
	~grainAttack1Slider.drawLines_(true);
	~grainAttack1Slider.action = {arg xb;
								~envelopeSynth.set("grain1Attack"++(xb.index), ~attackSpec0.map(xb.value.at(xb.index)););
								~granularMacroSynth1.set("grain1Attack"++(xb.index), ~attackSpec0.map(xb.value.at(xb.index)););
							   ~textEditor.stringColor_(Color.red (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainAttack1 " ++ ~attackSpec0.map(xb.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~grainAttack1Slider.valueAction = " ++ ~grainAttack1Slider.value.asString ++  ";
		~grainAttack1Array0 = Array.fill(13, {arg i;
		~envelopeSynth.set(\"grain1Attack\" ++ i.asString, ~attackSpec0.map(~grainAttack1Slider.value[i.value]))});}.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	};

// create multislider for release of granular synthesizers triggered by control two
	~grainRelease1Slider = MultiSliderView(~w8, Rect(((1920/3)/4)*6, 123+60, 1920/6, 60));
	~grainRelease1Slider.value_(Array.fill(13, {arg i; 0.1;}));
	~grainRelease1Slider.fillColor_(Color.red.alpha_(0.8));
	~grainRelease1Slider.strokeColor_(Color.red.alpha_(0.8));
	~grainRelease1Slider.background_(Color.gray.alpha_(0));
	~grainRelease1Slider.editable_(true);
	~grainRelease1Slider.elasticMode_(1);
	~grainRelease1Slider.thumbSize_(7);
	~grainRelease1Slider.drawLines_(true);
	~grainRelease1Slider.action = {arg xb;
								~envelopeSynth.set("grain1Release"++(xb.index), ~attackSpec0.map(xb.value.at(xb.index)););
								~granularMacroSynth1.set("grain1Release"++(xb.index), ~attackSpec0.map(xb.value.at(xb.index)););
							   ~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainRelease0 " ++ ~attackSpec0.map(xb.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~grainRelease1Slider.valueAction = " ++ ~grainRelease1Slider.value.asString ++  ";
		~grainRelease1Array0 = Array.fill(13, {arg i;
		~envelopeSynth.set(\"grain1Release\" ++ i.asString, ~attackSpec0.map(~grainRelease1Slider.value[i.value]))});}.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);

								};

// create multislider for amplitude of granular synthesizers triggered by control two
	~grainAmplitude1Slider = MultiSliderView(~w8, Rect(((1920/3)/4)*6, 0, 1920/6, 120));
	~grainAmplitude1Slider.value_(Array.fill(13, {arg i; 0;}));
	~grainAmplitude1Slider.fillColor_(Color.red.alpha_(0.8));
	~grainAmplitude1Slider.strokeColor_(Color.red.alpha_(0.8));
	~grainAmplitude1Slider.background_(Color.gray.alpha_(0));
	~grainAmplitude1Slider.editable_(true);
	~grainAmplitude1Slider.elasticMode_(1);
	~grainAmplitude1Slider.thumbSize_(7);
	~grainAmplitude1Slider.drawLines_(true);
	~grainAmplitude1Slider.action = {arg xb;
								~envelopeSynth.set(
								"grain1Amplitude"++(xb.index), ~volumeSpec0.map(xb.value.at(xb.index));
								);
								~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainAmplitude1 " ++ ~volumeSpec0.map(xb.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~grainAmplitude1Slider.valueAction = " ++ ~grainAmplitude1Slider.value.asString ++  ";
		~grainAmplitude1Array0 = Array.fill(13, {arg i;
		~envelopeSynth.set(\"grain1Amplitude\" ++ i.asString, ~volumeSpec0.map(~grainAmplitude1Slider.value[i.value]))});}.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};
// create multislider for amplitude of granular synthesizers triggered by control three/slave
	~grainAmplitude2Slider = MultiSliderView(~w8, Rect(((1920/3)/4)*10, 0, (1920/6)-5, 120));
	~grainAmplitude2Slider.value_(Array.fill(13, {arg i; 0;}));
	~grainAmplitude2Slider.fillColor_(Color.blue.alpha_(0.8));
	~grainAmplitude2Slider.strokeColor_(Color.blue.alpha_(0.8));
	~grainAmplitude2Slider.background_(Color.gray.alpha_(0));
	~grainAmplitude2Slider.editable_(false);
	~grainAmplitude2Slider.elasticMode_(1);
	~grainAmplitude2Slider.thumbSize_(7);
	~grainAmplitude2Slider.drawLines_(true);

// create multislider for attack of granular synthesizers triggered by control three/slave
	~grainAttack2Slider = MultiSliderView(~w8, Rect(((1920/3)/4)*10, 123, (1920/6)-5, 60));
	~grainAttack2Slider.value_(Array.fill(13, {arg i; 0.1;}));
	~grainAttack2Slider.fillColor_(Color.blue.alpha_(0.8));
	~grainAttack2Slider.strokeColor_(Color.blue.alpha_(0.8));
	~grainAttack2Slider.background_(Color.gray.alpha_(0));
	~grainAttack2Slider.editable_(false);
	~grainAttack2Slider.elasticMode_(1);
	~grainAttack2Slider.thumbSize_(7);
	~grainAttack2Slider.drawLines_(true);

// create multislider for release of granular synthesizers triggered by control three/slave
	~grainRelease2Slider = MultiSliderView(~w8, Rect(((1920/3)/4)*10, 123+60, (1920/6)-5, 60));
	~grainRelease2Slider.value_(Array.fill(13, {arg i; 0.1;}));
	~grainRelease2Slider.fillColor_(Color.blue.alpha_(0.8));
	~grainRelease2Slider.strokeColor_(Color.blue.alpha_(0.8));
	~grainRelease2Slider.background_(Color.gray.alpha_(0));
	~grainRelease2Slider.editable_(false);
	~grainRelease2Slider.elasticMode_(1);
	~grainRelease2Slider.thumbSize_(7);
	~grainRelease2Slider.drawLines_(true);

// create multislider for threshold of granular synthesizers triggered by control one
	~onsetThresholdSlider0 = MultiSliderView(~w8, Rect(0, 123, 1920/6, 120));
	~onsetThresholdSlider0.value_(Array.fill(13, {arg i; 0.2;}));
	~onsetThresholdSlider0.fillColor_(Color.yellow.alpha_(0.8));
	~onsetThresholdSlider0.strokeColor_(Color.yellow.alpha_(0.8));
	~onsetThresholdSlider0.background_(Color.gray.alpha_(0));
	~onsetThresholdSlider0.elasticMode_(1);
	~onsetThresholdSlider0.thumbSize_(14);
	~onsetThresholdSlider0.drawLines_(true);
	~onsetThresholdSlider0.action = {arg xb;
								~analysisSynth.set(
							   "osc0OnsetThreshold"++(xb.index), ~thresholdSpec0.map(xb.value.at(xb.index));
							   );
							   ~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainThreshold0 " ++ ~thresholdSpec0.map(xb.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~onsetThresholdSlider0.valueAction = " ++ ~onsetThresholdSlider0.value.asString ++  ";
		~onsetThresholdArray0 = Array.fill(13, {arg i;
		~analysisSynth.set(\"osc0OnsetThreshold\" ++ i.asString, ~thresholdSpec0.map(~onsetThresholdSlider0.value[i.value]))});}.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

// create multislider for threshold of granular synthesizers triggered by control two
	~onsetThresholdSlider1 = MultiSliderView(~w8, Rect(((1920/3)/4)*4, 123, 1920/6, 120));
	~onsetThresholdSlider1.value_(Array.fill(13, {arg i; 0.2;}));
	~onsetThresholdSlider1.fillColor_(Color.red.alpha_(0.8));
	~onsetThresholdSlider1.strokeColor_(Color.red.alpha_(0.8));
	~onsetThresholdSlider1.background_(Color.gray.alpha_(0));
	~onsetThresholdSlider1.elasticMode_(1);
	~onsetThresholdSlider1.thumbSize_(14);
	~onsetThresholdSlider1.drawLines_(true);
	~onsetThresholdSlider1.action = {arg xb;
								~analysisSynth.set(
							   "osc1OnsetThreshold"++(xb.index), ~thresholdSpec0.map(xb.value.at(xb.index));
							   );
							   ~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainThreshold1 " ++ ~thresholdSpec0.map(xb.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~onsetThresholdSlider1.valueAction = " ++ ~onsetThresholdSlider1.value.asString ++  ";
		~onsetThresholdArray1 = Array.fill(13, {arg i;
		~analysisSynth.set(\"osc1OnsetThreshold\" ++ i.asString, ~thresholdSpec0.map(~onsetThresholdSlider1.value[i.value]))});}.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

// create multislider for threshold of granular synthesizers triggered by control three/slave
	~onsetThresholdSlider2 = MultiSliderView(~w8, Rect(((1920/3)/4)*8, 123, 1920/6, 120));
	~onsetThresholdSlider2.value_(Array.fill(13, {arg i; 0.2;}));
	~onsetThresholdSlider2.fillColor_(Color.blue.alpha_(0.8));
	~onsetThresholdSlider2.strokeColor_(Color.blue.alpha_(0.8));
	~onsetThresholdSlider2.background_(Color.gray.alpha_(0));
	~onsetThresholdSlider2.editable_(false);
	~onsetThresholdSlider2.elasticMode_(1);
	~onsetThresholdSlider2.drawLines_(true);
	~onsetThresholdSlider2.thumbSize_(14);

// create multislider for duration of granular synthesizers triggered by control one
	~onsetDurationSlider0 = MultiSliderView(~w8, Rect(0, 246, 1920/6, 120));
	~onsetDurationSlider0.value_(Array.fill(13, {arg i; 1/4;}));
	~onsetDurationSlider0.fillColor_(Color.yellow.alpha_(0.8));
	~onsetDurationSlider0.strokeColor_(Color.yellow.alpha_(0.8));
	~onsetDurationSlider0.background_(Color.gray.alpha_(0));
	~onsetDurationSlider0.elasticMode_(1);
	~onsetDurationSlider0.thumbSize_(14);
	~onsetDurationSlider0.drawLines_(true);
	~onsetDurationSlider0.action = {arg xb;
							  	~granularMacroSynth0.set(
							   "onset0Duration"++(xb.index), ~durationSpec0.map(xb.value.at(xb.index));
							   );
							   ~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainDuration0 " ++ ~durationSpec0.map(xb.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~onsetDurationSlider0.valueAction = " ++ ~onsetDurationSlider0.value.asString ++  ";
		~onset0DurationArray0 = Array.fill(13, {arg i;
		~granularMacroSynth0.set(\"onset0Duration\" ++ i.asString, ~durationSpec0.map(~onsetDurationSlider0.value[i.value]))});}.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

// create multislider for threshold of granular synthesizers triggered by control two
	~onsetDurationSlider1 = MultiSliderView(~w8, Rect(((1920/3)/4)*4, 246, 1920/6, 120));
	~onsetDurationSlider1.value_(Array.fill(13, {arg i; 1/4;}));
	~onsetDurationSlider1.fillColor_(Color.red.alpha_(0.8));
	~onsetDurationSlider1.strokeColor_(Color.red.alpha_(0.8));
	~onsetDurationSlider1.background_(Color.gray.alpha_(0));
	~onsetDurationSlider1.elasticMode_(1);
	~onsetDurationSlider1.thumbSize_(14);
	~onsetDurationSlider1.drawLines_(true);
	~onsetDurationSlider1.action = {arg xb;
							   	~granularMacroSynth1.set(
							   "onset1Duration"++(xb.index), ~durationSpec0.map(xb.value.at(xb.index));
							   );
							   ~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainDuration1 " ++ ~durationSpec0.map(xb.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~onsetDurationSlider1.valueAction = " ++ ~onsetDurationSlider1.value.asString ++  ";
		~onset0DurationArray1 = Array.fill(13, {arg i;
		~granularMacroSynth1.set(\"onset1Duration\" ++ i.asString, ~durationSpec0.map(~onsetDurationSlider1.value[i.value]));}.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

// create multislider for threshold of granular synthesizers triggered by control three/slave
	~feedbackDurationSlider0 = MultiSliderView(~w8, Rect(((1920/3)/4)*8, 246, 1920/6, 120));
	~feedbackDurationSlider0.value_(Array.fill(13, {arg i; 1/4;}));
	~feedbackDurationSlider0.fillColor_(Color.blue.alpha_(0.8));
	~feedbackDurationSlider0.strokeColor_(Color.blue.alpha_(0.8));
	~feedbackDurationSlider0.background_(Color.gray.alpha_(0));
	~feedbackDurationSlider0.editable_(false);
	~feedbackDurationSlider0.drawLines_(true);
	~feedbackDurationSlider0.elasticMode_(1);
	~feedbackDurationSlider0.thumbSize_(14);

// create multislider for filter of granular synthesizers triggered by control one
	~filterFreqSlider0 = MultiSliderView(~w8, Rect(0, 0, 1920/6, 120));
	~filterFreqSlider0.value_(Array.fill(13, {arg i; 1/400;}));
	~filterFreqSlider0.fillColor_(Color.yellow.alpha_(0.8));
	~filterFreqSlider0.strokeColor_(Color.yellow);
	~filterFreqSlider0.background_(Color.gray.alpha_(0));
	~filterFreqSlider0.elasticMode_(1);
	~filterFreqSlider0.thumbSize_(14);
	~filterFreqSlider0.drawLines_(true);
	~filterFreqSlider0.action = {arg xb;
								~granularMacroSynth0.set(
							   "osc0Freq"++(xb.index), ~filterSpec0.map(xb.value.at(xb.index));
							   );
							   ~analysisSynth.set(
							   "osc0Freq"++(xb.index), ~filterSpec0.map(xb.value.at(xb.index));
							   );
							   ~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainFilter0 " ++ ~filterSpec0.map(xb.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~filterFreqSlider0.valueAction = " ++ ~filterFreqSlider0.value.asString ++  ";
		~filterFreq0Array0 = Array.fill(13, {arg i;
		~granularMacroSynth0.set(\"osc0Freq\" ++ i.asString, ~filterSpec0.map(~filterFreqSlider0.value[i.value]))});
		~filterFreq0Array1 = Array.fill(13, {arg i;
		~analysisSynth.set(\"osc0Freq\" ++ i.asString, ~filterSpec0.map(~filterFreqSlider0.value[i.value]))});}.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

// create multislider for filter of granular synthesizers triggered by control two
	~filterFreqSlider1 = MultiSliderView(~w8, Rect(((1920/3)/4)*4, 0, 1920/6, 120));
	~filterFreqSlider1.value_(Array.fill(13, {arg i; 1/400;}));
	~filterFreqSlider1.fillColor_(Color.red.alpha_(0.8));
	~filterFreqSlider1.strokeColor_(Color.red);
	~filterFreqSlider1.background_(Color.gray.alpha_(0));
	~filterFreqSlider1.elasticMode_(1);
	~filterFreqSlider1.thumbSize_(14);
	~filterFreqSlider1.drawLines_(true);
	~filterFreqSlider1.action = {arg xb;
								~granularMacroSynth1.set(
							   "osc1Freq"++(xb.index), ~filterSpec0.map(xb.value.at(xb.index));
							   );
							   ~analysisSynth.set(
							   "osc1Freq"++(xb.index), ~filterSpec0.map(xb.value.at(xb.index));
							   );
							   ~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainFilter1 " ++ ~filterSpec0.map(xb.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~filterFreqSlider1.valueAction = " ++ ~filterFreqSlider1.value.asString ++  ";
		~filterFreq1Array0 = Array.fill(13, {arg i;
		~granularMacroSynth1.set(\"osc1Freq\" ++ i.asString, ~filterSpec0.map(~filterFreqSlider1.value[i.value]))});
		~filterFreq1Array1 = Array.fill(13, {arg i;
		~analysisSynth.set(\"osc1Freq\" ++ i.asString, ~filterSpec0.map(~filterFreqSlider1.value[i.value]))});}.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

// create multislider for threshold of granular synthesizers triggered by control three/slave
	~filterFreqSlider2 = MultiSliderView(~w8, Rect(((1920/3)/4)*8, 0, 1920/6, 120));
	~filterFreqSlider2.value_(Array.fill(13, {arg i; 1/400;}));
	~filterFreqSlider2.fillColor_(Color.blue.alpha_(0.8));
	~filterFreqSlider2.strokeColor_(Color.blue);
	~filterFreqSlider2.background_(Color.gray.alpha_(0));
	~filterFreqSlider2.elasticMode_(1);
	~filterFreqSlider2.thumbSize_(14);
	~filterFreqSlider2.drawLines_(true);
	~filterFreqSlider2.action = {arg xb;
								~granularMacroSynth2.set(
							   "osc2Freq"++(xb.index), ~filterSpec0.map(xb.value.at(xb.index));
							   );
							   ~analysisSynth.set(
							   "osc2Freq"++(xb.index), ~filterSpec0.map(xb.value.at(xb.index));
							   );
							   ~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainFilter2 " ++ ~filterSpec0.map(xb.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~filterFreqSlider2.valueAction = " ++ ~filterFreqSlider2.value.asString ++  ";
		~filterFreq2Array0 = Array.fill(13, {arg i;
		~granularMacroSynth2.set(\"osc2Freq\" ++ i.asString, ~filterSpec0.map(~filterFreqSlider2.value[i.value]))});
		~filterFreq2Array1 = Array.fill(13, {arg i;
		~analysisSynth.set(\"osc2Freq\" ++ i.asString, ~filterSpec0.map(~filterFreqSlider2.value[i.value]))});}.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

// create multislider for playback rate of granular synthesizers triggered by control one
	~pitch0Slider0 = MultiSliderView(~w8, Rect(((1920/3)/4)*2, 246, 1920/6, 120));
	~pitch0Slider0.value_(Array.fill(13, {arg i; 0.5 + (1/8);}));
	~pitch0Slider0.fillColor_(Color.yellow.alpha_(0.8));
	~pitch0Slider0.strokeColor_(Color.yellow.alpha_(0.8));
	~pitch0Slider0.background_(Color.gray.alpha_(0));
	~pitch0Slider0.elasticMode_(1);
	~pitch0Slider0.thumbSize_(7);
	~pitch0Slider0.drawLines_(true);
	~pitch0Slider0.action = {arg xb;

							   ~granularMacroSynth0.set(
							   "grain0Pitch"++(xb.index), ~grainPitch0Spec0.map(xb.value.at(xb.index));
							   );

							   ~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainRate0 " ++ ~grainPitch0Spec0.map(xb.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~pitch0Slider0.valueAction = " ++ ~grainPitch0Spec0.value.asString ++  ";
		~pitch0Slider0Array = Array.fill(13, {arg i;
		~granularMacroSynth0.set(\"grain0Pitch\" ++ i.asString, ~grainPitch0Spec0.map(~pitch0Slider0.value[i.value]));}); }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

// create multislider for playback rate of granular synthesizers triggered by control two
	~pitch1Slider0 = MultiSliderView(~w8, Rect(((1920/3)/4)*6, 246, 1920/6, 120));
	~pitch1Slider0.value_(Array.fill(13, {arg i; 0.5 + (1/8);}));
	~pitch1Slider0.fillColor_(Color.red.alpha_(0.8));
	~pitch1Slider0.strokeColor_(Color.red.alpha_(0.8));
	~pitch1Slider0.background_(Color.gray.alpha_(0));
	~pitch1Slider0.elasticMode_(1);
	~pitch1Slider0.thumbSize_(7);
	~pitch1Slider0.drawLines_(true);
	~pitch1Slider0.action = {arg xb;

							  	~granularMacroSynth1.set(
							   "grain1Pitch"++(xb.index), ~grainPitch0Spec0.map(xb.value.at(xb.index));
							   );

							   ~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
							   	~textEditor.string_(" \n\n " ++ ~clockOut ++ " grainRate1 " ++  ~grainPitch0Spec0.map(xb.value).round(0.1) ++ " ", (~textEditor.string.size), (~textEditor.string.size));
								~textEditor.selectLine(~textEditor.string.size);
								~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~pitch1Slider0.valueAction = " ++ ~grainPitch0Spec0.value.asString ++  ";
		~pitch1Slider0Array = Array.fill(13, {arg i;
		~granularMacroSynth1.set(\"grain1Pitch\" ++ i.asString, ~grainPitch0Spec0.map(~pitch1Slider0.value[i.value]));}); }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
								};

// create multislider for playback rate of granular synthesizers triggered by control three/slave
	~pitch2Slider0 = MultiSliderView(~w8, Rect(((1920/3)/4)*10, 246, (1920/6)-5, 120));
	~pitch2Slider0.value_(Array.fill(13, {arg i; 0.5 + (1/8);}));
	~pitch2Slider0.fillColor_(Color.blue.alpha_(0.8));
	~pitch2Slider0.strokeColor_(Color.blue.alpha_(0.8));
	~pitch2Slider0.background_(Color.gray.alpha_(0));
	~pitch2Slider0.editable_(false);
	~pitch2Slider0.elasticMode_(1);
	~pitch2Slider0.thumbSize_(7);
	~pitch2Slider0.drawLines_(true);

// create toggle button for fractal playback rate of granular synthesizers triggered by control one
	~fractal0Button0 = Array.new(13);
	~fractal0ButtonArray0 = Array.fill(13, {arg i;
	~fractal0Button0.add(Button(~w8, Rect((((1920/3)/4)*2) + (i * (1920/6)/13.2), 246, (1920/6)/13, 14)));
	~fractal0Button0[i].states_([
					["Off", Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["On", Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);
	~fractal0Button0[i].font_(Font("Monaco", 10));
	~fractal0Button0[i].action = {arg butt;

		if(butt.value == 1,
		{~granularMacroSynth0.set("fractal0Grain" ++ i.asString, 1);
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " fractal0Grain" ++ i.asString ++ " On " ++ " ", (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.selectLine(~textEditor.string.size);
		~saveText.string_(" \n\n " " if(
		~clockGUI == " ++ ~clockGUI ++  "," ++
		"{{ ~fractal0Button0[" ++ i.asString ++ "].valueAction = " ++ ~fractal0Button0[i].value.asString ++  " }.defer;}); ",
		(~saveText.string.size), (~saveText.string.size));
		~saveText.selectLine(~saveText.string.size);},
		{~granularMacroSynth0.set("fractal0Grain" ++ i.asString, 0);
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " fractal0Grain" ++ i.asString ++ " Off " ++ " ", (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.selectLine(~textEditor.string.size);
		~saveText.string_(" \n\n " " if(
		~clockGUI == " ++ ~clockGUI ++  "," ++
		"{{ ~fractal0Button0[" ++ i.asString ++ "].valueAction = " ++ ~fractal0Button0[i].value.asString ++  " }.defer;}); ",
		(~saveText.string.size), (~saveText.string.size));
		~saveText.selectLine(~saveText.string.size);		});
	};
	});

// create toggle button for fractal playback rate of granular synthesizers triggered by control two
	~fractal1Button0 = Array.new(13);
	~fractal1ButtonArray0 = Array.fill(13, {arg i;
	~fractal1Button0.add(Button(~w8, Rect((((1920/3)/4)*6) + (i * (1920/6)/13.2), 246, (1920/6)/13, 14)));
	~fractal1Button0[i].states_([
					["Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["On", Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);
	~fractal1Button0[i].font_(Font("Monaco", 10));
	~fractal1Button0[i].action = {arg butt;

		if(butt.value == 1,
		{~granularMacroSynth1.set("fractal1Grain" ++ i.asString, 1);
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " fractal1Grain" ++ i.asString ++ " On " ++ " ", (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.selectLine(~textEditor.string.size);
		~saveText.string_(" \n\n " " if(
		~clockGUI == " ++ ~clockGUI ++  "," ++
		"{{ ~fractal1Button0[" ++ i.asString ++ "].valueAction = " ++ ~fractal1Button0[i].value.asString ++  " }.defer;}); ",
		(~saveText.string.size), (~saveText.string.size));
		~saveText.selectLine(~saveText.string.size);		},
		{~granularMacroSynth1.set("fractal1Grain" ++ i.asString, 0);
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " fractal1Grain" ++ i.asString ++ " Off " ++ " ", (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.selectLine(~textEditor.string.size);
		~saveText.string_(" \n\n " " if(
		~clockGUI == " ++ ~clockGUI ++  "," ++
		"{{ ~fractal1Button0[" ++ i.asString ++ "].valueAction = " ++ ~fractal1Button0[i].value.asString ++  " }.defer;}); ",
		(~saveText.string.size), (~saveText.string.size));
		~saveText.selectLine(~saveText.string.size);				});
	};
	});

// create toggle button for fractal playback rate of granular synthesizers triggered by control three/slave
	~fractal2Button0 = Array.new(13);
	~fractal2ButtonArray0 = Array.fill(13, {arg i;
	~fractal2Button0.add(Button(~w8, Rect((((1920/3)/4)*10) + (i * (1920/6)/13.4), 246, (1920/6)/13, 14)));
	~fractal2Button0[i].states_([
					["Off", Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["On", Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);
	~fractal2Button0[i].font_(Font("Monaco", 10));
	~fractal2Button0[i].action = {arg butt;

		if(butt.value == 1,
		{~granularMacroSynth2.set("fractal2Grain" ++ i.asString, 1);
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " fractal2Grain" ++ i.asString ++ " On " ++ " ", (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.selectLine(~textEditor.string.size);
		~saveText.string_(" \n\n " " if(
		~clockGUI == " ++ ~clockGUI ++  "," ++
		"{{ ~fractal2Button0[" ++ i.asString ++ "].valueAction = " ++ ~fractal2Button0[i].value.asString ++  " }.defer;}); ",
		(~saveText.string.size), (~saveText.string.size));
		~saveText.selectLine(~saveText.string.size);				},
		{~granularMacroSynth2.set("fractal2Grain" ++ i.asString, 0);
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " fractal2Grain" ++ i.asString ++ " Off " ++ " ", (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.selectLine(~textEditor.string.size);
		~saveText.string_(" \n\n " " if(
		~clockGUI == " ++ ~clockGUI ++  "," ++
		"{{ ~fractal2Button0[" ++ i.asString ++ "].valueAction = " ++ ~fractal2Button0[i].value.asString ++  " }.defer;}); ",
		(~saveText.string.size), (~saveText.string.size));
		~saveText.selectLine(~saveText.string.size);						});
	};
	});

// create toggle button for fractal recording rate of granular synthesizers triggered by control one
	~natural0Button0 = Array.new(13);
	~natural0ButtonArray0 = Array.fill(13, {arg i;
	~natural0Button0.add(Button(~w8, Rect((((1920/3)/4)*2) + (i * (1920/6)/13.2), 350, (1920/6)/13, 14)));
	~natural0Button0[i].states_([
					["Off", Color.black.alpha_(0.8),Color.yellow.alpha_(0.8)],
					["On", Color.yellow.alpha_(0.8),Color.black.alpha_(0.8)],
							]);
	~natural0Button0[i].font_(Font("Monaco", 10));
	~natural0Button0[i].action = {arg butt;

		if(butt.value == 1,
		{~decimateSynth0.set("naturalChooser" ++ i.asString, 1);
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " natural0Chooser" ++ i.asString ++ " On " ++ " ", (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.selectLine(~textEditor.string.size);
		~saveText.string_(" \n\n " " if(
		~clockGUI == " ++ ~clockGUI ++  "," ++
		"{{ ~natural0Button0[" ++ i.asString ++ "].valueAction = " ++ ~natural0Button0[i].value.asString ++  " }.defer;}); ",
		(~saveText.string.size), (~saveText.string.size));
		~saveText.selectLine(~saveText.string.size);},
		{~decimateSynth0.set("naturalChooser" ++ i.asString, 0);
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " natural0Chooser" ++ i.asString ++ " Off " ++ " ", (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.selectLine(~textEditor.string.size);
		~saveText.string_(" \n\n " " if(
		~clockGUI == " ++ ~clockGUI ++  "," ++
		"{{ ~natural0Button0[" ++ i.asString ++ "].valueAction = " ++ ~natural0Button0[i].value.asString ++  " }.defer;}); ",
		(~saveText.string.size), (~saveText.string.size));
		~saveText.selectLine(~saveText.string.size);		});
	};
	});

// create toggle button for fractal recording rate of granular synthesizers triggered by control two
	~natural1Button0 = Array.new(13);
	~natural1ButtonArray0 = Array.fill(13, {arg i;
	~natural1Button0.add(Button(~w8, Rect((((1920/3)/4)*6) + (i * (1920/6)/13.2), 350, (1920/6)/13, 14)));
	~natural1Button0[i].states_([
					["Off", Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["On", Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);
	~natural1Button0[i].font_(Font("Monaco", 10));
	~natural1Button0[i].action = {arg butt;

		if(butt.value == 1,
		{~decimateSynth1.set("naturalChooser" ++ i.asString, 1);
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " natural1Chooser" ++ i.asString ++ " On " ++ " ", (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.selectLine(~textEditor.string.size);
		~saveText.string_(" \n\n " " if(
		~clockGUI == " ++ ~clockGUI ++  "," ++
		"{{ ~natural1Button0[" ++ i.asString ++ "].valueAction = " ++ ~natural1Button0[i].value.asString ++  " }.defer;}); ",
		(~saveText.string.size), (~saveText.string.size));
		~saveText.selectLine(~saveText.string.size);		},
		{~decimateSynth1.set("naturalChooser" ++ i.asString, 0);
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " natural1Chooser" ++ i.asString ++ " Off " ++ " ", (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.selectLine(~textEditor.string.size);
		~saveText.string_(" \n\n " " if(
		~clockGUI == " ++ ~clockGUI ++  "," ++
		"{{ ~natural1Button0[" ++ i.asString ++ "].valueAction = " ++ ~natural1Button0[i].value.asString ++  " }.defer;}); ",
		(~saveText.string.size), (~saveText.string.size));
		~saveText.selectLine(~saveText.string.size);				});
	};
	});

// create toggle button for fractal recording rate of granular synthesizers triggered by control three/slave
	~natural2Button0 = Array.new(13);
	~natural2ButtonArray0 = Array.fill(13, {arg i;
	~natural2Button0.add(Button(~w8, Rect((((1920/3)/4)*10) + (i * (1920/6)/13.4), 350, (1920/6)/13, 14)));
	~natural2Button0[i].states_([
					["Off", Color.white.alpha_(0.8),Color.blue.alpha_(0.8)],
					["On", Color.blue.alpha_(0.8),Color.white.alpha_(0.8)],
							]);
	~natural2Button0[i].font_(Font("Monaco", 10));
	~natural2Button0[i].action = {arg butt;

		if(butt.value == 1,
		{~decimateSynth2.set("naturalChooser" ++ i.asString, 1);
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " natural2Chooser" ++ i.asString ++ " On " ++ " ", (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.selectLine(~textEditor.string.size);
		~saveText.string_(" \n\n " " if(
		~clockGUI == " ++ ~clockGUI ++  "," ++
		"{{ ~natural2Button0[" ++ i.asString ++ "].valueAction = " ++ ~natural2Button0[i].value.asString ++  " }.defer;}); ",
		(~saveText.string.size), (~saveText.string.size));
		~saveText.selectLine(~saveText.string.size);				},
		{~decimateSynth2.set("naturalChooser" ++ i.asString, 0);
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " natural2Chooser" ++ i.asString ++ " Off " ++ " ", (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.selectLine(~textEditor.string.size);
		~saveText.string_(" \n\n " " if(
		~clockGUI == " ++ ~clockGUI ++  "," ++
		"{{ ~natural2Button0[" ++ i.asString ++ "].valueAction = " ++ ~natural2Button0[i].value.asString ++  " }.defer;}); ",
		(~saveText.string.size), (~saveText.string.size));
		~saveText.selectLine(~saveText.string.size);						});
	};
	});


	~w8.front;

// set GUI to Cocoa
	GUI.cocoa;

// toggle post actions to post window
	~textEditorButton = Button(~w6, Rect(125, 275, 100, 25));
	~textEditorButton.font = Font("Monaco", 10);
	~textEditorButton.states = ([["Post Off", Color.white, Color.black.alpha_(0.8)], ["Post On", Color.black.alpha_(0.8), Color.white]]);
	~textEditorButton.action = {arg butt;
	if( butt.value == 1,
	{
	~textEditor.editable = true;
	},

	{
	~textEditor.editable = false;
	});};


// input selector for control one
	~inputSwitch0 = PopUpMenu(~w6, Rect(225, 50, 100, 50));
	~inputSwitch0.items = ["Sample", "Synth", "Mic"];
	~inputSwitch0.font_(Font("Monaco", 10));
	~inputSwitch0.background = Color.yellow.alpha_(0.8);

	~inputSwitch0.action_({arg menu;
	if ( menu.value == 0,
	{~bufferSynth.set(\osc0Chooser0, 0); ~attackText0[23].string_("sample on"); ~sampleViewer0.drawsWaveForm_(true); ~sampleViewer0.setSelectionColor(0, Color.white.alpha_(0.8));
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Control Yellow Set to Sample "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~inputSwitch0.valueAction = " ++ ~inputSwitch0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	};
	);
	if ( menu.value == 1,
	{~bufferSynth.set(\osc0Chooser0, 1); ~attackText0[23].string_("synth on"); ~sampleViewer0.drawsWaveForm_(false); ~sampleViewer0.setSelectionColor(0, Color.clear);
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Control Yellow Set to Synth "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~inputSwitch0.valueAction  = " ++ ~inputSwitch0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	};
	);
	if ( menu.value == 2,
	{~bufferSynth.set(\osc0Chooser0, 2); ~attackText0[23].string_("mic input on"); ~sampleViewer0.drawsWaveForm_(false); ~sampleViewer0.setSelectionColor(0, Color.clear);
		~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Control Yellow set to Mic "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~inputSwitch0.valueAction  = " ++ ~inputSwitch0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	};
	);
	});

// input selector for control two
	~inputSwitch1 = PopUpMenu(~w6, Rect(225, 100, 100, 50));
	~inputSwitch1.items = ["Sample", "Synth", "Mic"];
	~inputSwitch1.font_(Font("Monaco", 10));
	~inputSwitch1.background = Color.red.alpha_(0.8);
	~inputSwitch1.stringColor = Color.white.alpha_(0.8);

	~inputSwitch1.action_({arg menu;
	if ( menu.value == 0,
	{~bufferSynth.set(\osc1Chooser0, 0); ~onText0.string_("sample on"); ~sampleViewer1.drawsWaveForm_(true); ~sampleViewer1.setSelectionColor(0, Color.white.alpha_(0.8));
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Control Red Set to Sample "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~inputSwitch1.valueAction  = " ++ ~inputSwitch1.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);	};
	);
	if ( menu.value == 1,
	{~bufferSynth.set(\osc1Chooser0, 1); ~onText0.string_("synth on"); ~sampleViewer1.drawsWaveForm_(false); ~sampleViewer1.setSelectionColor(0, Color.clear);
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Control Red Set to Synth "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~inputSwitch1.valueAction  = " ++ ~inputSwitch1.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);	}
	);
	if ( menu.value == 2,
	{~bufferSynth.set(\osc1Chooser0, 2); ~onText0.string_("mic input on"); ~sampleViewer1.drawsWaveForm_(false); ~sampleViewer1.setSelectionColor(0, Color.clear);
		~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Control Red Set to Mic "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~inputSwitch1.valueAction  = " ++ ~inputSwitch1.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);	}
	);
	});

// input selector for control three
	~inputSwitch2 = PopUpMenu(~w6, Rect(225, 150, 100, 50));
	~inputSwitch2.items = ["Sample", "Synth", "Mic"];
	~inputSwitch2.font_(Font("Monaco", 10));
	~inputSwitch2.background = Color.blue.alpha_(0.8);
	~inputSwitch2.stringColor = Color.white.alpha_(0.8);

	~inputSwitch2.action_({arg menu;
	if ( menu.value == 0,
	{~bufferSynth.set(\osc2Chooser0, 0); ~attackText0[24].string_("sample on"); ~sampleViewer2.drawsWaveForm_(true); ~bufferSynth.set(\tempoChooser0, 0); ~sampleViewer2.setSelectionColor(0, Color.white.alpha_(0.8));
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Control Blue Set to Sample "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~inputSwitch2.valueAction  = " ++ ~inputSwitch2.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);	};
	);

	if ( menu.value == 1,
	{~bufferSynth.set(\osc2Chooser0, 1); ~attackText0[24].string_("synth on"); ~bufferSynth.set(\synthMicChooser0, 0); ~sampleViewer2.drawsWaveForm_(false); ~bufferSynth.set(\tempoChooser0, 1); ~sampleViewer2.setSelectionColor(0, Color.clear);
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Control Blue Set to Synth "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~inputSwitch2.valueAction  = " ++ ~inputSwitch2.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);	};
	);

	if ( menu.value == 2,
	{~bufferSynth.set(\osc2Chooser0, 1); ~attackText0[24].string_("mic input on"); ~bufferSynth.set(\synthMicChooser0, 1); ~sampleViewer2.drawsWaveForm_(false);  ~length = ~inputBuffer.numFrames; ~start = 0;  ~bufferSynth.set(\tempoChooser0, 2); ~sampleViewer2.setSelectionColor(0, Color.clear);
		~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Control Blue Set to Mic "  ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~inputSwitch2.valueAction  = " ++ ~inputSwitch2.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);	};
	);
	});

// toggle record for live sampling
	~recordSwitch0 = Button(~w6, Rect(125, 25, 100, 25));
	~recordSwitch0.font_(Font("Monaco", 10));
	~recordSwitch0.states_([
					["Record Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Record On",Color.red.alpha_(0.8),Color.white.alpha_(0.8)],
							]);

	~recordSwitch0.action_({arg butt;
	if ( butt.value == 1,
	{~recordBuffer0.free;
		~recordBuffer0 = Buffer.alloc(s, s.sampleRate * ~recordLengthInput0.value.asInteger.max(1), 2, bufnum:226);
		~fxSynth.set(\recordOn, 1); ~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.string_(" \n\n " ++ ~clockOut ++ " Recording... ", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size); },
	{~fxSynth.set(\recordOn, 0); ~recordBuffer0.write(sampleFormat: 'int16'); ~quickLoadPath0 = (thisProcess.platform.recordingsDir +/+ "SC_" ++ Date.localtime.stamp ++ ".aiff");
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Recording Saved as " ++ ("SC_" ++ Date.localtime.stamp.asString ++ ".aiff"), (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);}
	)
	});

// display local IP address
	~ipView = StaticText(~w6, Rect(225, 266, 200, 50));
	~ipView.string = "local ip = " ++ Pipe.new("ifconfig en1 | grep \"inet \" | awk '{print $2}'" , "r").getLine;
	~ipView.font = Font("Monaco", 14);

// toggle live coding GUI
	~editButton = Button(~w6, Rect(325, 250, 100, 25));
	~editButton.font_(Font("Monaco", 10));
	~editButton.states_([
					["Score Off",Color.white.alpha_(0.8),Color.red.alpha_(0.8)],
					["Score On",Color.black.alpha_(0.8),Color.green.alpha_(0.8)],
							]);

	~editButton.action_({arg butt;
	if ((butt.value == 1) && (~clockOn0 == 0),
	{~saveText.editable =  false;
	~textEditor.editable = true;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Start Clock to Edit Score then re-click Score On ", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);
	~textEditor.editable = false;};
	);

	if ((butt.value == 1) && (~clockOn0 == 1),
	{~saveText.editable =  true;
	~textEditor.editable = true;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Score Editable ", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);
	~textEditor.editable = false;};
	);

	if (butt.value == 0,
	{~saveText.editable =  false;
	~textEditor.editable = true;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Score Edit Off ", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);
	~textEditor.editable = false;};
	);

	});

// allocater for live coded routine to control window
	~allocateTask0 = PopUpMenu(~w6, Rect(325, 225, 100, 25));
	~allocateTask0.items_(["None", "1" , "2" , "3" , "4", "5" , "6" , "7" , "8", "9" , "10" , "11" , "12", "13" , "14" , "15"]);
	~allocateTask0.font_(Font("Monaco", 10));

// create new live coded routine
	~newRoutineButton0 = Button(~w6, Rect(225, 225, 100, 25));
	~newRoutineButton0.states_([["Create...",Color.black,Color.gray],]);
	~newRoutineButton0.font_(Font("Monaco", 10));
	~newRoutineButton0.action_({|butt|

	~saveText.editable = true;

// place routine with controls to position one in Routine control window
	if(~allocateTask0.value == 1,
	{
	~saveText.string_(~taskString, (~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine0.clear;
	~taskPositionRoutine0 = ~saveText.string.interpret;
	~taskPositionString0 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size);
	~saveText.selectedString = "";
	~newTaskButton0.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 1 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton0.action_({|butt|

	if(~newTaskButton0.value == 0,
	{
	~taskPositionRoutine0.stop;
	},
	{
	~taskPositionRoutine0.reset;
	~taskPositionRoutine0.play;
	});
	});
	});

// place routine with controls to position two in Routine control window
	if(~allocateTask0.value == 2,
	{
	~saveText.string_(~taskString,

	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine1.clear;
	~taskPositionRoutine1 = ~saveText.string.interpret;
	~taskPositionString1 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size);
	~saveText.selectedString = "";
	~newTaskButton1.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 2 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton1.action_({|butt|

	if(~newTaskButton1.value == 0,
	{
	~taskPositionRoutine1.stop;
	},
	{
	~taskPositionRoutine1.reset;
	~taskPositionRoutine1.play;
	});
	});
	});

// place routine with controls to position three in Routine control window
	if(~allocateTask0.value == 3,
	{

	~saveText.string_(~taskString,

	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine2.clear;
	~taskPositionRoutine2 = ~saveText.string.interpret;
	~taskPositionString2 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size);
	~saveText.selectedString = "";
	~newTaskButton2.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 3 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton2.action_({|butt|

	if(~newTaskButton2.value == 0,
	{
	~taskPositionRoutine2.stop;
	},
	{
	~taskPositionRoutine2.reset;
	~taskPositionRoutine2.play;
	});
	});
	});

// place routine with controls to position four in Routine control window
	if(~allocateTask0.value == 4,
	{
	~saveText.string_(~taskString,

	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine3.clear;
	~taskPositionRoutine3 = ~saveText.string.interpret;
	~taskPositionString3 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size);
	~saveText.selectedString = "";
	~newTaskButton3.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 4 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton3.action_({|butt|

	if(~newTaskButton3.value == 0,
	{
	~taskPositionRoutine3.stop;
	},
	{
	~taskPositionRoutine3.reset;
	~taskPositionRoutine3.play;
	});
	});
	});

// place routine with controls to position five in Routine control window
	if(~allocateTask0.value == 5,
	{
	~saveText.string_(~taskString,

	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine4.clear;
	~taskPositionRoutine4 = ~saveText.string.interpret;
	~taskPositionString4 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size);
	~saveText.selectedString = "";
	~newTaskButton4.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 5 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton4.action_({|butt|

	if(~newTaskButton4.value == 0,
	{
	~taskPositionRoutine4.stop;
	},
	{
	~taskPositionRoutine4.reset;
	~taskPositionRoutine4.play;
	});
	});
	});

// place routine with controls to position six in Routine control window
	if(~allocateTask0.value == 6,
	{
	~saveText.string_(~taskString,

	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine5.clear;
	~taskPositionRoutine5 = ~saveText.string.interpret;
	~taskPositionString5 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size);
	~saveText.selectedString = "";
	~newTaskButton5.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 6 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton5.action_({|butt|

	if(~newTaskButton5.value == 0,
	{
	~taskPositionRoutine5.stop;
	},
	{
	~taskPositionRoutine5.reset;
	~taskPositionRoutine5.play;
	});
	});
	});

// place routine with controls to position seven in Routine control window
	if(~allocateTask0.value == 7,
	{
	~saveText.string_(~taskString,

	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine6.clear;
	~taskPositionRoutine6 = ~saveText.string.interpret;
	~taskPositionString6 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size);
	~saveText.selectedString = "";
	~newTaskButton6.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 7 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton6.action_({|butt|

	if(~newTaskButton6.value == 0,
	{
	~taskPositionRoutine6.stop;
	},
	{
	~taskPositionRoutine6.reset;
	~taskPositionRoutine6.play;
	});
	});
	});

// place routine with controls to position eight in Routine control window
	if(~allocateTask0.value == 8,
	{
	~saveText.string_(~taskString,

	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine7.clear;
	~taskPositionRoutine7 = ~saveText.string.interpret;
	~taskPositionString7 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size);
	~saveText.selectedString = "";
	~newTaskButton7.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 8 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton7.action_({|butt|

	if(~newTaskButton7.value == 0,
	{
	~taskPositionRoutine7.stop;
	},
	{
	~taskPositionRoutine7.reset;
	~taskPositionRoutine7.play;
	});
	});
	});

// place routine with controls to position nine in Routine control window
	if(~allocateTask0.value == 9,
	{
	~saveText.string_(~taskString,

	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine8.clear;
	~taskPositionRoutine8 = ~saveText.string.interpret;
	~taskPositionString8 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size);
	~saveText.selectedString = "";
	~newTaskButton8.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 9 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton8.action_({|butt|

	if(~newTaskButton8.value == 0,
	{
	~taskPositionRoutine8.stop;
	},
	{
	~taskPositionRoutine8.reset;
	~taskPositionRoutine8.play;
	});
	});
	});

// place routine with controls to position ten in Routine control window
	if(~allocateTask0.value == 10,
	{
	~saveText.string_(~taskString,

	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine9.clear;
	~taskPositionRoutine9 = ~saveText.string.interpret;
	~taskPositionString9 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size);
	~saveText.selectedString = "";
	~newTaskButton9.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 10 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton9.action_({|butt|

	if(~newTaskButton9.value == 0,
	{
	~taskPositionRoutine9.stop;
	},
	{
	~taskPositionRoutine9.reset;
	~taskPositionRoutine9.play;
	});
	});
	});

// place routine with controls to position eleven in Routine control window
	if(~allocateTask0.value == 11,
	{
	~saveText.string_(~taskString,

	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine10.clear;
	~taskPositionRoutine10 = ~saveText.string.interpret;
	~taskPositionString10 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size);
	~saveText.selectedString = "";
	~newTaskButton10.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 11 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton10.action_({|butt|

	if(~newTaskButton10.value == 0,
	{
	~taskPositionRoutine10.stop;
	},
	{
	~taskPositionRoutine10.reset;
	~taskPositionRoutine10.play;
	});
	});
	});

// place routine with controls to position twelve in Routine control window
	if(~allocateTask0.value == 12,
	{
	~saveText.string_(~taskString,

	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine11.clear;
	~taskPositionRoutine11 = ~saveText.string.interpret;
	~taskPositionString11 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size).postln;
	~saveText.selectedString = "";
	~newTaskButton11.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 12 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton11.action_({|butt|

	if(~newTaskButton11.value == 0,
	{
	~taskPositionRoutine11.stop;
	},
	{
	~taskPositionRoutine11.reset;
	~taskPositionRoutine11.play;
	});
	});
	});

// place routine with controls to position thirteen in Routine control window
	if(~allocateTask0.value == 13,
	{
	~saveText.string_(~taskString,

	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine12.clear;
	~taskPositionRoutine12 = ~saveText.string.interpret;
	~taskPositionString12 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size).postln;
	~saveText.selectedString = "";
	~newTaskButton12.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 13 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton12.action_({|butt|

	if(~newTaskButton12.value == 0,
	{
	~taskPositionRoutine12.stop;
	},
	{
	~taskPositionRoutine12.reset;
	~taskPositionRoutine12.play;
	});
	});
	});

// place routine with controls to position fourteen in Routine control window
	if(~allocateTask0.value == 14,
	{
	~saveText.string_(~taskString,

	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine13.clear;
	~taskPositionRoutine13 = ~saveText.string.interpret;
	~taskPositionString13 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size).postln;
	~saveText.selectedString = "";
	~newTaskButton13.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 14 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton13.action_({|butt|

	if(~newTaskButton13.value == 0,
	{
	~taskPositionRoutine13.stop;
	},
	{
	~taskPositionRoutine13.reset;
	~taskPositionRoutine13.play;
	});
	});
	});

// place routine with controls to position fifteen in Routine control window
	if(~allocateTask0.value == 15,
	{
	~saveText.string_(~taskString,

	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);
	~saveText.syntaxColorize;
	~taskPositionRoutine14.clear;
	~taskPositionRoutine14 = ~saveText.string.interpret;
	~taskPositionString14 = ~saveText.string;
	~saveText.selectRange(~saveText.string.size - (~taskString.size - 1), ~saveText.string.size).postln;
	~saveText.selectedString = "";
	~newTaskButton14.states_([[~saveName ++ "Stop",Color.black,Color.gray], [~saveName ++ "Stop",Color.black,Color.green],]);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " " ++ ~saveName ++ " loaded to 15 ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~newTaskButton14.action_({|butt|

	if(~newTaskButton14.value == 0,
	{
	~taskPositionRoutine14.stop;
	},
	{
	~taskPositionRoutine14.reset;
	~taskPositionRoutine14.play;
	});
	});
	});

	~w2.userCanClose = false;
	~w2.front;
	~saveText.editable =  false;
	~editButton.valueAction = 0;
	});

// set live coded routine name
	~routineName0 = TextField(~w6, Rect(225, 250, 100, 25));
	~routineName0.string = "routine";
	~routineName0.font_(Font("Monaco", 15));
	~routineName0.action = {arg field;
	~saveText.editable = true;
	~saveText.string = "";
	~saveText.background = Color.gray.alpha_(0);
	~saveName = "~" ++ field.value.asString;
	~saveText.selectRange(0, (~saveText.string.size));
	~saveText.selectedString = ~saveName ++ " = Routine({
	inf.do ({ arg i; ";
	~saveText.syntaxColorize;
	~saveText.editable = false;
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Session Cleared and Name Changed to " ++ ~saveName ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);};

// open existing file to a window
	~textEditorNewButton0 = Button(~w6, Rect(225, 200, 200, 25));
	~textEditorNewButton0.states_([["Open .rtf file",Color.black,Color.gray]]);
	~textEditorNewButton0.font_(Font("Monaco", 10));
	~textEditorNewButton0.action_({arg menu;

			CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0, i;
			~textOpen = Document.open(path0.asString);
			~textOpen.bounds_(Rect((1920/6)*1.5, 175, 1920/4, 150));
			~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Opened "  ++ path0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);

			});
			});
			});

	~recordLengthInput0 = TextField(~w6, Rect(25, 25, 100, 25));
	~recordLengthInput0.font_(Font("Monaco", 10));
	~recordLengthInput0.string = "1.0";
	~recordLengthInput0.stringColor = Color.white.alpha_(0.8);
	~recordLengthInput0.background = Color.red.alpha_(0.8);
	~recordLengthInput0.action = {arg field;
		~recordBuffer0.free;
		~recordBuffer0 = Buffer.alloc(s, s.sampleRate * field.value.asInteger.max(1), 2, bufnum:226);
		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Record Length = "  ++  field.value.asString ++ " seconds", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);
	};

// set length of buffer for granular synthesizers
	~grainLengthInput0 = TextField(~w6, Rect(425, 25, 50, 25));
	~grainLengthInput0.font_(Font("Monaco", 10));
	~grainLengthInput0.string = "4";
	~grainLengthInput0.stringColor = Color.black.alpha_(0.8);
	~grainLengthInput0.background = Color.white.alpha_(0.8);
	~grainLengthInput0.action = {arg field;

	~warpBuffer0.free;
	~warpBuffer1.free;
	~warpBuffer2.free;

	~warpBuffer0 = Array.new(13);
	~warpBufferArray0 = Array.fill(13, {arg i;
	~warpBuffer0.add(Buffer.alloc(s, (s.sampleRate) * field.value.asInteger.max(1), 1, bufnum:(1008 + (i * 2))));
	});

	~warpBuffer1 = Array.new(13);
	~warpBufferArray1 = Array.fill(13, {arg i;
	~warpBuffer1.add(Buffer.alloc(s, (s.sampleRate) * field.value.asInteger.max(1), 1, bufnum:(1122 + (i * 2))));
	});

	~warpBuffer2 = Array.new(13);
	~warpBufferArray2 = Array.fill(13, {arg i;
	~warpBuffer2.add(Buffer.alloc(s, (s.sampleRate) * field.value.asInteger.max(1), 1, bufnum:(1200 + (i * 2))));
	});

		~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
		~textEditor.string_(" \n\n " ++ ~clockOut ++ " Grain Buffer Length = "  ++  field.value.asString ++ " seconds", (~textEditor.string.size), (~textEditor.string.size)); ~textEditor.selectLine(~textEditor.string.size);
	};

	~bufferSelector0 = c;
	~sampleSelector0 = ~sampleViewer0;
	~sampleFileSelected = ~sampleFile0;
	~numFramesSelector = ~cnumFrames;
	~dnaSelector0 = ~dna0;
	~loadSelector0 = "Yellow";

// select destination of live sample
	~quickLoadSelector0 = PopUpMenu(~w6, Rect(225 + (200/2), 25, 200/2, 25));
	~quickLoadSelector0.font_(Font("Monaco", 10));
	~quickLoadSelector0.items = ["to Yellow", "to Red", "to Blue"];
	~quickLoadSelector0.background = Color.yellow.alpha_(0.8);
	~quickLoadSelector0.action = {arg menu;
		if (menu.value == 0,
		{	~bufferSelector0 = c;
			~sampleSelector0 = ~sampleViewer0;
			~sampleFileSelected = ~sampleFile0;
			~numFramesSelector = ~cnumFrames;
			~dnaSelector0 = ~dna0;
			~loadSelector0 = "Yellow";
			~quickLoadSelector0.background = Color.yellow.alpha_(0.8);
			~quickLoadSelector0.stringColor = Color.black.alpha_(0.8);

		};);

		if (menu.value == 1,
		{	~bufferSelector0 = d;
			~sampleSelector0 = ~sampleViewer1;
			~sampleFileSelected = ~sampleFile1;
			~numFramesSelector = ~dnumFrames;
			~dnaSelector0 = ~dna1;
			~loadSelector0 = "Red";
			~quickLoadSelector0.background = Color.red.alpha_(0.8);
			~quickLoadSelector0.stringColor = Color.white.alpha_(0.8);
		};);

		if (menu.value == 2,
		{	~bufferSelector0 = b;
			~sampleSelector0 = ~sampleViewer2;
			~sampleFileSelected = ~sampleFile2;
			~numFramesSelector = ~bnumFrames;
			~dnaSelector0 = ~child;
			~loadSelector0 = "Blue";
			~quickLoadSelector0.background = Color.blue.alpha_(0.8);
			~quickLoadSelector0.stringColor = Color.white.alpha_(0.8);
		};);
	};

// execture loading of live sample
	~quickLoad0 = Button(~w6, Rect(225, 25, 200/2, 25));
	~quickLoad0.font_(Font("Monaco", 10));
	~quickLoad0.states_([
					["Quick Load",Color.black,Color.white],
							]);

	~quickLoad0.action_({arg butt;
	~bufferSelector0.free;
	~bufferSelector0.allocRead(~quickLoadPath0.asString);
	~sampleFileSelected.openRead(~quickLoadPath0.asString);
	~sampleSelector0.soundfile = ~sampleFileSelected;
	~sampleSelector0.read(0, ~sampleFileSelected.numFrames);
	~sampleSelector0.refresh;
	~numFramesSelector = ~sampleFileSelected.numFrames;
	~bufferSynth.set("start" ++ ~quickLoadSelector0.value.asString, 0, "end" ++ ~quickLoadSelector0.value.asString, ~sampleFileSelected.numFrames);
	if(~quickLoadSelector0.value == 0,
	{~textEditor.stringColor_(Color.yellow, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Quick Loaded File to "  ++  ~loadSelector0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});
	if(~quickLoadSelector0.value == 1,
	{~textEditor.stringColor_(Color.red, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Quick Loaded File to "  ++  ~loadSelector0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});
	if(~quickLoadSelector0.value == 2,
	{~textEditor.stringColor_(Color.blue, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Quick Loaded File to "  ++  ~loadSelector0.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	});
	if (~bufferSelector0 == b,
	{~length = ~sampleFileSelected.numFrames;
	 ~start = 0; };
	);
	~dnaSelector0.add(1);
	});

// clock minutes value adjuster
~clockMinutesAdjust = NumberBox(~w6, Rect(425, 0, 25, 25));
~clockMinutesAdjust.value = 0;
~clockMinutesAdjust.clipLo = 0;
~clockMinutesAdjust.font = Font("Monaco", 18);
~clockMinutesAdjust.action = {arg numb;
	~clockMinutes = numb.value + 1;
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Clock Start Minutes set to " ++ numb.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
};

// clock seconds value adjuster
~clockSecondsAdjust = NumberBox(~w6, Rect(450, 0, 25, 25));
~clockSecondsAdjust.value = 0;
~clockSecondsAdjust.clipLo = 0;
~clockSecondsAdjust.font = Font("Monaco", 18);
~clockSecondsAdjust.action = {arg numb;
	~clockSeconds = numb.value;
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Clock Start Seconds set to " ++ numb.value.asString ++ " ", (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
};

// create window for live coded GUI routines, with load, save and execute buttons
	~w2 = Window("Routine Controls", Rect((1920/3), 400, 300, 250), false, true, scroll: true);
	~w2.alwaysOnTop = true;

// create button in position one for playback control of relative routine
	~newTaskButton0 = Button(~w2, Rect(0, 0, 100, 25));
	~newTaskButton0.states_([["Empty",Color.black,Color.gray], ["Empty Play",Color.black,Color.green],]);
	~newTaskButton0.font_(Font("Monaco", 10));
	~newTaskButton0.action_({|butt|
	});

// create button in position one to save relative routine to file
	~newTaskSaveButton0 = Button(~w2, Rect(0, 25, 50, 25));
	~newTaskSaveButton0.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton0.font_(Font("Monaco", 10));
	~newTaskSaveButton0.action_({|butt|
	~newTaskSaveFile0 = Document.new("Routine1", ~taskPositionString0, makeListener: false);

	});

// create button in position one to load relative routine to file
	~newTaskLoadButton0 = Button(~w2, Rect(50, 25, 50, 25));
	~newTaskLoadButton0.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton0.font_(Font("Monaco", 10));
	~newTaskLoadButton0.action_({
	~newTaskButton0.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument0 = Document.open(path0.asString);
			~taskPositionRoutine0.clear;
			~newTaskLoadName0 = ~newTaskLoadDocument0.selectRange(0, 5);
			~newTaskLoadName0 = ~newTaskLoadName0.selectedString;
			~taskPositionString0 = ~newTaskLoadDocument0.string;
			~taskPositionRoutine0 = ~newTaskLoadDocument0.string.interpret;
			~newTaskLoadDocument0.close;
			~newTaskButton0.states_([[~newTaskLoadName0 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName0 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton0.action_({|butt|

			if(~newTaskButton0.value == 0,
			{
			~taskPositionRoutine0.stop;
			},
			{
			~taskPositionRoutine0.reset;
			~taskPositionRoutine0.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine1 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// create button in position two for playback control of relative routine
	~newTaskButton1 = Button(~w2, Rect(100, 0, 100, 25));
	~newTaskButton1.states_([["Empty",Color.black,Color.gray],]);
	~newTaskButton1.font_(Font("Monaco", 10));
	~newTaskButton1.action_({|butt|
	});

// create button in position two to save relative routine to file
	~newTaskSaveButton1 = Button(~w2, Rect(100, 25, 50, 25));
	~newTaskSaveButton1.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton1.font_(Font("Monaco", 10));
	~newTaskSaveButton1.action_({|butt|
	~newTaskSaveFile1 = Document.new("Routine2", ~taskPositionString1, makeListener: false);

	});

// create button in position two to load relative routine to file
	~newTaskLoadButton1 = Button(~w2, Rect(150, 25, 50, 25));
	~newTaskLoadButton1.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton1.font_(Font("Monaco", 10));
	~newTaskLoadButton1.action_({
	~newTaskButton1.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument1 = Document.open(path0.asString);
			~taskPositionRoutine1.clear;
			~newTaskLoadName1 = ~newTaskLoadDocument1.selectRange(0, 5);
			~newTaskLoadName1 = ~newTaskLoadName1.selectedString;
			~taskPositionString1 = ~newTaskLoadDocument1.string;
			~taskPositionRoutine1 = ~newTaskLoadDocument1.string.interpret;
			~newTaskLoadDocument1.close;
			~newTaskButton1.states_([[~newTaskLoadName1 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName1 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton1.action_({|butt|

			if(~newTaskButton1.value == 0,
			{
			~taskPositionRoutine1.stop;
			},
			{
			~taskPositionRoutine1.reset;
			~taskPositionRoutine1.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine2 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// create button in position three for playback control of relative routine
	~newTaskButton2 = Button(~w2, Rect(200, 0, 100, 25));
	~newTaskButton2.states_([["Empty",Color.black,Color.gray],]);
	~newTaskButton2.font_(Font("Monaco", 10));
	~newTaskButton2.action_({|butt|
	});

// create button in position three to save relative routine to file
	~newTaskSaveButton2 = Button(~w2, Rect(200, 25, 50, 25));
	~newTaskSaveButton2.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton2.font_(Font("Monaco", 10));
	~newTaskSaveButton2.action_({|butt|
	~newTaskSaveFile2 = Document.new("Routine3", ~taskPositionString2, makeListener: false);

	});

// create button in position three to load relative routine to file
	~newTaskLoadButton2 = Button(~w2, Rect(250, 25, 50, 25));
	~newTaskLoadButton2.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton2.font_(Font("Monaco", 10));
	~newTaskLoadButton2.action_({
	~newTaskButton2.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument2 = Document.open(path0.asString);
			~taskPositionRoutine2.clear;
			~newTaskLoadName2 = ~newTaskLoadDocument2.selectRange(0, 5);
			~newTaskLoadName2 = ~newTaskLoadName2.selectedString;
			~taskPositionString2 = ~newTaskLoadDocument2.string;
			~taskPositionRoutine2 = ~newTaskLoadDocument2.string.interpret;
			~newTaskLoadDocument2.close;
			~newTaskButton2.states_([[~newTaskLoadName2 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName2 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton2.action_({|butt|

			if(~newTaskButton2.value == 0,
			{
			~taskPositionRoutine2.stop;
			},
			{
			~taskPositionRoutine2.reset;
			~taskPositionRoutine2.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine3 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// create button in position four for playback control of relative routine
	~newTaskButton3 = Button(~w2, Rect(0, 50, 100, 25));
	~newTaskButton3.states_([["Empty",Color.black,Color.gray],]);
	~newTaskButton3.font_(Font("Monaco", 10));
	~newTaskButton3.action_({|butt|
	});

// create button in position four to save relative routine to file
	~newTaskSaveButton3 = Button(~w2, Rect(0, 75, 50, 25));
	~newTaskSaveButton3.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton3.font_(Font("Monaco", 10));
	~newTaskSaveButton3.action_({|butt|
	~newTaskSaveFile3 = Document.new("Routine4", ~taskPositionString3, makeListener: false);

	});

// create button in position four to load relative routine to file
	~newTaskLoadButton3 = Button(~w2, Rect(50, 75, 50, 25));
	~newTaskLoadButton3.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton3.font_(Font("Monaco", 10));
	~newTaskLoadButton3.action_({
	~newTaskButton3.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument3 = Document.open(path0.asString);
			~taskPositionRoutine3.clear;
			~newTaskLoadName3 = ~newTaskLoadDocument3.selectRange(0, 5);
			~newTaskLoadName3 = ~newTaskLoadName3.selectedString;
			~taskPositionString3 = ~newTaskLoadDocument3.string;
			~taskPositionRoutine3 = ~newTaskLoadDocument3.string.interpret;
			~newTaskLoadDocument3.close;
			~newTaskButton3.states_([[~newTaskLoadName3 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName3 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton3.action_({|butt|

			if(~newTaskButton3.value == 0,
			{
			~taskPositionRoutine3.stop;
			},
			{
			~taskPositionRoutine3.reset;
			~taskPositionRoutine3.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine4 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// create button in position five for playback control of relative routine
	~newTaskButton4 = Button(~w2, Rect(100, 50, 100, 25));
	~newTaskButton4.states_([["Empty",Color.black,Color.gray],]);
	~newTaskButton4.font_(Font("Monaco", 10));
	~newTaskButton4.action_({|butt|
	});

// create button in position five to save relative routine to file
	~newTaskSaveButton4 = Button(~w2, Rect(100, 75, 50, 25));
	~newTaskSaveButton4.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton4.font_(Font("Monaco", 10));
	~newTaskSaveButton4.action_({|butt|
	~newTaskSaveFile4 = Document.new("Routine5", ~taskPositionString4, makeListener: false);

	});

// create button in position five to load relative routine to file
	~newTaskLoadButton4 = Button(~w2, Rect(150, 75, 50, 25));
	~newTaskLoadButton4.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton4.font_(Font("Monaco", 10));
	~newTaskLoadButton4.action_({
	~newTaskButton4.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument4 = Document.open(path0.asString);
			~taskPositionRoutine4.clear;
			~newTaskLoadName4 = ~newTaskLoadDocument4.selectRange(0, 5);
			~newTaskLoadName4 = ~newTaskLoadName4.selectedString;
			~taskPositionString4 = ~newTaskLoadDocument4.string;
			~taskPositionRoutine4 = ~newTaskLoadDocument4.string.interpret;
			~newTaskLoadDocument4.close;
			~newTaskButton4.states_([[~newTaskLoadName4 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName4 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton4.action_({|butt|

			if(~newTaskButton4.value == 0,
			{
			~taskPositionRoutine4.stop;
			},
			{
			~taskPositionRoutine4.reset;
			~taskPositionRoutine4.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine5 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// create button in position six for playback control of relative routine
	~newTaskButton5 = Button(~w2, Rect(200, 50, 100, 25));
	~newTaskButton5.states_([["Empty",Color.black,Color.gray],]);
	~newTaskButton5.font_(Font("Monaco", 10));
	~newTaskButton5.action_({|butt|
	});

// create button in position six to save relative routine to file
	~newTaskSaveButton5 = Button(~w2, Rect(200, 75, 50, 25));
	~newTaskSaveButton5.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton5.font_(Font("Monaco", 10));
	~newTaskSaveButton5.action_({|butt|
	~newTaskSaveFile5 = Document.new("Routine6", ~taskPositionString5, makeListener: false);

	});

// create button in position six to load relative routine to file
	~newTaskLoadButton5 = Button(~w2, Rect(250, 75, 50, 25));
	~newTaskLoadButton5.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton5.font_(Font("Monaco", 10));
	~newTaskLoadButton5.action_({
	~newTaskButton5.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument5 = Document.open(path0.asString);
			~taskPositionRoutine5.clear;
			~newTaskLoadName5 = ~newTaskLoadDocument5.selectRange(0, 5);
			~newTaskLoadName5 = ~newTaskLoadName5.selectedString;
			~taskPositionString5 = ~newTaskLoadDocument5.string;
			~taskPositionRoutine5 = ~newTaskLoadDocument5.string.interpret;
			~newTaskLoadDocument5.close;
			~newTaskButton5.states_([[~newTaskLoadName5 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName5 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton5.action_({|butt|

			if(~newTaskButton5.value == 0,
			{
			~taskPositionRoutine5.stop;
			},
			{
			~taskPositionRoutine5.reset;
			~taskPositionRoutine5.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine6 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// create button in position seven for playback control of relative routine
	~newTaskButton6 = Button(~w2, Rect(0, 100, 100, 25));
	~newTaskButton6.states_([["Empty",Color.black,Color.gray],]);
	~newTaskButton6.font_(Font("Monaco", 10));
	~newTaskButton6.action_({|butt|
	});

// create button in position seven to save relative routine to file
	~newTaskSaveButton6 = Button(~w2, Rect(0, 125, 50, 25));
	~newTaskSaveButton6.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton6.font_(Font("Monaco", 10));
	~newTaskSaveButton6.action_({|butt|
	~newTaskSaveFile6 = Document.new("Routine7", ~taskPositionString6, makeListener: false);

	});

// create button in position seven to load relative routine to file
	~newTaskLoadButton6 = Button(~w2, Rect(50, 125, 50, 25));
	~newTaskLoadButton6.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton6.font_(Font("Monaco", 10));
	~newTaskLoadButton6.action_({
	~newTaskButton6.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument6 = Document.open(path0.asString);
			~taskPositionRoutine6.clear;
			~newTaskLoadName6 = ~newTaskLoadDocument6.selectRange(0, 5);
			~newTaskLoadName6 = ~newTaskLoadName6.selectedString;
			~taskPositionString6 = ~newTaskLoadDocument6.string;
			~taskPositionRoutine6 = ~newTaskLoadDocument6.string.interpret;
			~newTaskLoadDocument6.close;
			~newTaskButton6.states_([[~newTaskLoadName6 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName6 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton6.action_({|butt|

			if(~newTaskButton6.value == 0,
			{
			~taskPositionRoutine6.stop;
			},
			{
			~taskPositionRoutine6.reset;
			~taskPositionRoutine6.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine7 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// create button in position eight for playback control of relative routine
	~newTaskButton7 = Button(~w2, Rect(100, 100, 100, 25));
	~newTaskButton7.states_([["Empty",Color.black,Color.gray],]);
	~newTaskButton7.font_(Font("Monaco", 10));
	~newTaskButton7.action_({|butt|
	});

// create button in position eight to save relative routine to file
	~newTaskSaveButton7 = Button(~w2, Rect(100, 125, 50, 25));
	~newTaskSaveButton7.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton7.font_(Font("Monaco", 10));
	~newTaskSaveButton7.action_({|butt|
	~newTaskSaveFile7 = Document.new("Routine8", ~taskPositionString7, makeListener: false);

	});

// create button in position eight to load relative routine to file
	~newTaskLoadButton7 = Button(~w2, Rect(150, 125, 50, 25));
	~newTaskLoadButton7.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton7.font_(Font("Monaco", 10));
	~newTaskLoadButton7.action_({
	~newTaskButton7.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument7 = Document.open(path0.asString);
			~taskPositionRoutine7.clear;
			~newTaskLoadName7 = ~newTaskLoadDocument7.selectRange(0, 5);
			~newTaskLoadName7 = ~newTaskLoadName7.selectedString;
			~taskPositionString7 = ~newTaskLoadDocument7.string;
			~taskPositionRoutine7 = ~newTaskLoadDocument7.string.interpret;
			~newTaskLoadDocument7.close;
			~newTaskButton7.states_([[~newTaskLoadName7 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName7 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton7.action_({|butt|

			if(~newTaskButton7.value == 0,
			{
			~taskPositionRoutine7.stop;
			},
			{
			~taskPositionRoutine7.reset;
			~taskPositionRoutine7.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine8 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// create button in position nine for playback control of relative routine
	~newTaskButton8 = Button(~w2, Rect(200, 100, 100, 25));
	~newTaskButton8.states_([["Empty",Color.black,Color.gray],]);
	~newTaskButton8.font_(Font("Monaco", 10));
	~newTaskButton8.action_({|butt|
	});

// create button in position nine to save relative routine to file
	~newTaskSaveButton8 = Button(~w2, Rect(200, 125, 50, 25));
	~newTaskSaveButton8.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton8.font_(Font("Monaco", 10));
	~newTaskSaveButton8.action_({|butt|
	~newTaskSaveFile8 = Document.new("Routine9", ~taskPositionString8, makeListener: false);

	});

// create button in position nine to load relative routine to file
	~newTaskLoadButton8 = Button(~w2, Rect(250, 125, 50, 25));
	~newTaskLoadButton8.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton8.font_(Font("Monaco", 10));
	~newTaskLoadButton8.action_({
	~newTaskButton8.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument8 = Document.open(path0.asString);
			~taskPositionRoutine8.clear;
			~newTaskLoadName8 = ~newTaskLoadDocument8.selectRange(0, 5);
			~newTaskLoadName8 = ~newTaskLoadName8.selectedString;
			~taskPositionString8 = ~newTaskLoadDocument8.string;
			~taskPositionRoutine8 = ~newTaskLoadDocument8.string.interpret;
			~newTaskLoadDocument8.close;
			~newTaskButton8.states_([[~newTaskLoadName8 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName8 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton8.action_({|butt|

			if(~newTaskButton8.value == 0,
			{
			~taskPositionRoutine8.stop;
			},
			{
			~taskPositionRoutine8.reset;
			~taskPositionRoutine8.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine9 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// create button in position ten for playback control of relative routine
	~newTaskButton9 = Button(~w2, Rect(0, 150, 100, 25));
	~newTaskButton9.states_([["Empty",Color.black,Color.gray],]);
	~newTaskButton9.font_(Font("Monaco", 10));
	~newTaskButton9.action_({|butt|
	});

// create button in position ten to save relative routine to file
	~newTaskSaveButton9 = Button(~w2, Rect(0, 175, 50, 25));
	~newTaskSaveButton9.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton9.font_(Font("Monaco", 10));
	~newTaskSaveButton9.action_({|butt|
	~newTaskSaveFile9 = Document.new("Routine10", ~taskPositionString9, makeListener: false);

	});

// create button in position ten to load relative routine to file
	~newTaskLoadButton9 = Button(~w2, Rect(50, 175, 50, 25));
	~newTaskLoadButton9.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton9.font_(Font("Monaco", 10));
	~newTaskLoadButton9.action_({
	~newTaskButton9.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument9 = Document.open(path0.asString);
			~taskPositionRoutine9.clear;
			~newTaskLoadName9 = ~newTaskLoadDocument9.selectRange(0, 5);
			~newTaskLoadName9 = ~newTaskLoadName9.selectedString;
			~taskPositionString9 = ~newTaskLoadDocument9.string;
			~taskPositionRoutine9 = ~newTaskLoadDocument9.string.interpret;
			~newTaskLoadDocument9.close;
			~newTaskButton9.states_([[~newTaskLoadName9 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName9 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton9.action_({|butt|

			if(~newTaskButton9.value == 0,
			{
			~taskPositionRoutine9.stop;
			},
			{
			~taskPositionRoutine9.reset;
			~taskPositionRoutine9.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine10 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// create button in position eleven for playback control of relative routine
	~newTaskButton10 = Button(~w2, Rect(100, 150, 100, 25));
	~newTaskButton10.states_([["Empty",Color.black,Color.gray],]);
	~newTaskButton10.font_(Font("Monaco", 10));
	~newTaskButton10.action_({|butt|
	});

// create button in position eleven to save relative routine to file
	~newTaskSaveButton10 = Button(~w2, Rect(100, 175, 50, 25));
	~newTaskSaveButton10.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton10.font_(Font("Monaco", 10));
	~newTaskSaveButton10.action_({|butt|
	~newTaskSaveFile10 = Document.new("Routine11", ~taskPositionString10, makeListener: false);

	});

// create button in position eleven to load relative routine to file
	~newTaskLoadButton10 = Button(~w2, Rect(150, 175, 50, 25));
	~newTaskLoadButton10.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton10.font_(Font("Monaco", 10));
	~newTaskLoadButton10.action_({
	~newTaskButton10.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument10 = Document.open(path0.asString);
			~taskPositionRoutine10.clear;
			~newTaskLoadName10 = ~newTaskLoadDocument10.selectRange(0, 5);
			~newTaskLoadName10 = ~newTaskLoadName10.selectedString;
			~taskPositionString10 = ~newTaskLoadDocument10.string;
			~taskPositionRoutine10 = ~newTaskLoadDocument10.string.interpret;
			~newTaskLoadDocument10.close;
			~newTaskButton10.states_([[~newTaskLoadName10 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName10 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton10.action_({|butt|

			if(~newTaskButton10.value == 0,
			{
			~taskPositionRoutine10.stop;
			},
			{
			~taskPositionRoutine10.reset;
			~taskPositionRoutine10.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine11 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// create button in position twelve for playback control of relative routine
	~newTaskButton11 = Button(~w2, Rect(200, 150, 100, 25));
	~newTaskButton11.states_([["Empty",Color.black,Color.gray],]);
	~newTaskButton11.font_(Font("Monaco", 10));
	~newTaskButton11.action_({|butt|
	});

// create button in position twelve to save relative routine to file
	~newTaskSaveButton11 = Button(~w2, Rect(200, 175, 50, 25));
	~newTaskSaveButton11.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton11.font_(Font("Monaco", 10));
	~newTaskSaveButton11.action_({|butt|
	~newTaskSaveFile11 = Document.new("Routine12", ~taskPositionString11, makeListener: false);

	});

// create button in position twelve to load relative routine to file
	~newTaskLoadButton11 = Button(~w2, Rect(250, 175, 50, 25));
	~newTaskLoadButton11.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton11.font_(Font("Monaco", 10));
	~newTaskLoadButton11.action_({
	~newTaskButton11.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument11 = Document.open(path0.asString);
			~taskPositionRoutine11.clear;
			~newTaskLoadName11 = ~newTaskLoadDocument11.selectRange(0, 5);
			~newTaskLoadName11 = ~newTaskLoadName11.selectedString;
			~taskPositionString11 = ~newTaskLoadDocument11.string;
			~taskPositionRoutine11 = ~newTaskLoadDocument11.string.interpret;
			~newTaskLoadDocument11.close;
			~newTaskButton11.states_([[~newTaskLoadName11 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName11 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton11.action_({|butt|

			if(~newTaskButton11.value == 0,
			{
			~taskPositionRoutine11.stop;
			},
			{
			~taskPositionRoutine11.reset;
			~taskPositionRoutine11.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine12 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// create button in position thirteen for playback control of relative routine
	~newTaskButton12 = Button(~w2, Rect(0, 200, 100, 25));
	~newTaskButton12.states_([["Empty",Color.black,Color.gray],]);
	~newTaskButton12.font_(Font("Monaco", 10));
	~newTaskButton12.action_({|butt|
	});

// create button in position thirteen to save relative routine to file
	~newTaskSaveButton12 = Button(~w2, Rect(0, 225, 50, 25));
	~newTaskSaveButton12.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton12.font_(Font("Monaco", 10));
	~newTaskSaveButton12.action_({|butt|
	~newTaskSaveFile12 = Document.new("Routine13", ~taskPositionString12, makeListener: false);

	});

// create button in position thirteen to load relative routine to file
	~newTaskLoadButton12 = Button(~w2, Rect(50, 225, 50, 25));
	~newTaskLoadButton12.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton12.font_(Font("Monaco", 10));
	~newTaskLoadButton12.action_({
	~newTaskButton12.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument12 = Document.open(path0.asString);
			~taskPositionRoutine12.clear;
			~newTaskLoadName12 = ~newTaskLoadDocument12.selectRange(0, 5);
			~newTaskLoadName12 = ~newTaskLoadName12.selectedString;
			~taskPositionString12 = ~newTaskLoadDocument12.string;
			~taskPositionRoutine12 = ~newTaskLoadDocument12.string.interpret;
			~newTaskLoadDocument12.close;
			~newTaskButton12.states_([[~newTaskLoadName12 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName12 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton12.action_({|butt|

			if(~newTaskButton12.value == 0,
			{
			~taskPositionRoutine12.stop;
			},
			{
			~taskPositionRoutine12.reset;
			~taskPositionRoutine12.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine13 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// create button in position fourteen for playback control of relative routine
	~newTaskButton13 = Button(~w2, Rect(100, 200, 100, 25));
	~newTaskButton13.states_([["Empty",Color.black,Color.gray],]);
	~newTaskButton13.font_(Font("Monaco", 10));
	~newTaskButton13.action_({|butt|
	});

// create button in position fourteen to save relative routine to file
	~newTaskSaveButton13 = Button(~w2, Rect(100, 225, 50, 25));
	~newTaskSaveButton13.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton13.font_(Font("Monaco", 10));
	~newTaskSaveButton13.action_({|butt|
	~newTaskSaveFile13 = Document.new("Routine14", ~taskPositionString13, makeListener: false);

	});

// create button in position fourteen to load relative routine to file
	~newTaskLoadButton13 = Button(~w2, Rect(150, 225, 50, 25));
	~newTaskLoadButton13.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton13.font_(Font("Monaco", 10));
	~newTaskLoadButton13.action_({
	~newTaskButton13.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument13 = Document.open(path0.asString);
			~taskPositionRoutine13.clear;
			~newTaskLoadName13 = ~newTaskLoadDocument13.selectRange(0, 5);
			~newTaskLoadName13 = ~newTaskLoadName13.selectedString;
			~taskPositionString13 = ~newTaskLoadDocument13.string;
			~taskPositionRoutine13 = ~newTaskLoadDocument13.string.interpret;
			~newTaskLoadDocument13.close;
			~newTaskButton13.states_([[~newTaskLoadName13 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName13 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton13.action_({|butt|

			if(~newTaskButton13.value == 0,
			{
			~taskPositionRoutine13.stop;
			},
			{
			~taskPositionRoutine13.reset;
			~taskPositionRoutine13.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine14 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// create button in position fifteen for playback control of relative routine
	~newTaskButton14 = Button(~w2, Rect(200, 200, 100, 25));
	~newTaskButton14.states_([["Empty",Color.black,Color.gray],]);
	~newTaskButton14.font_(Font("Monaco", 10));
	~newTaskButton14.action_({|butt|
	});

// create button in position fifteen to save relative routine to file
	~newTaskSaveButton14 = Button(~w2, Rect(200, 225, 50, 25));
	~newTaskSaveButton14.states_([["Save",Color.gray,Color.black],]);
	~newTaskSaveButton14.font_(Font("Monaco", 10));
	~newTaskSaveButton14.action_({|butt|
	~newTaskSaveFile14 = Document.new("Routine15", ~taskPositionString14, makeListener: false);

	});

// create button in position fifteen to load relative routine to file
	~newTaskLoadButton14 = Button(~w2, Rect(250, 225, 50, 25));
	~newTaskLoadButton14.states_([["Load",Color.gray,Color.black],]);
	~newTaskLoadButton14.font_(Font("Monaco", 10));
	~newTaskLoadButton14.action_({
	~newTaskButton14.valueAction = 0;
	CocoaDialog.getPaths({ arg paths;
			paths.do({ arg path0;
			~newTaskLoadDocument14 = Document.open(path0.asString);
			~taskPositionRoutine14.clear;
			~newTaskLoadName14 = ~newTaskLoadDocument14.selectRange(0, 5);
			~newTaskLoadName14 = ~newTaskLoadName14.selectedString;
			~taskPositionString14 = ~newTaskLoadDocument14.string;
			~taskPositionRoutine14 = ~newTaskLoadDocument14.string.interpret;
			~newTaskLoadDocument14.close;
			~newTaskButton14.states_([[~newTaskLoadName14 ++ "Stop",Color.black,Color.gray], [~newTaskLoadName14 ++ "Stop",Color.black,Color.green],]);
			~newTaskButton14.action_({|butt|

			if(~newTaskButton14.value == 0,
			{
			~taskPositionRoutine14.stop;
			},
			{
			~taskPositionRoutine14.reset;
			~taskPositionRoutine14.play;
			});
			});
			~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
			~textEditor.string_(" \n\n " ++ ~clockOut ++ " Routine15 from " ++ path0.asString ++ " ", (~textEditor.string.size),
			(~textEditor.string.size));
			~textEditor.selectLine(~textEditor.string.size);
				})
		});
	});

// default values of Call and Response
	~interactCounterOn = 0;
	~interactCount0 = 0;
	~interactEnvelope = 1;
	~interactTimeOut = 1;
	~interactPitch0 = 1;
	~interactPitch1 = 1;
	~interactPitchOut0 = 1;
	~interactPitchOut1 = 1;
	~waitCount0 = 0;
	~waitCountAdjuster0 = 0.1;
	~interactWindowOn = 0;
	~stopInteractGUI = 10;
	~interactPitchRound0 = 0;
	~waitCountAdjusterUpdate0 = 2;
	~interactTimeCounter = 0;
	~interactTimeSignature = 4;
	~interactTimeAdjust = [1, 1];
	~interactTimeSelector = [1, 1];
	~interactOnsetCounter = 0;
	~interactOnsetCounterOut = 0;
	~interactOnsetCalculator = 0;
	~interactStartPos = 0;
	~interactFinishPos = 0;
	~candenceOn = 0;
	~interactInput0 = [~powerReturn0, ~powerReturn1, ~powerReturn2, ~manualInteract0];
	~interactInputChooser0 = 3;


// pitch adjustment routines
	~noPitchAdjust = Routine {
		inf.do({ arg i;
	~interactPitchOut0 = 1;
	~interactPitchOut1 = 1;
	~interactPitchRound0 = 0;

	0.05.wait

	});
	};

	~octavePitchAdjust = Routine {
		inf.do({ arg i;
	~interactPitchOut0 = (~interactPitch0/2);
	~interactPitchOut1 = (~interactPitch1*2);
	~interactPitchRound0 = 1;

	0.05.wait

	});
	};

	~freePitchAdjust = Routine {
		inf.do({ arg i;
	~interactPitchOut0 = (~interactPitch0*0.25);
	~interactPitchOut1 = (~interactPitch1*4);
	~interactPitchRound0 = 0;

	0.05.wait

	});
	};


// pitch adjustement toggle
	~interactPitchChooser0 = PopUpMenu(~w5, Rect(200, 175, 50, 25));
	~interactPitchChooser0.items = ["None", "Octaves", "Free"];
	~interactPitchChooser0.font_(Font("Monaco", 10));
	~interactPitchChooser0.action = {arg menu;

	if(menu.value == 0,
	{

	~noPitchAdjust.reset;
	~noPitchAdjust.play;
	~octavePitchAdjust.stop;
	~freePitchAdjust.stop;

	});

	if(menu.value == 1,
	{

	~octavePitchAdjust.reset;
	~octavePitchAdjust.play;
	~noPitchAdjust.stop;
	~freePitchAdjust.stop;

	});

	if(menu.value == 2,
	{

	~freePitchAdjust.reset;
	~freePitchAdjust.play;
	~noPitchAdjust.stop;
	~octavePitchAdjust.stop;

	});

	};

// select Call source
	~interactInputPop0 = PopUpMenu(~w5, Rect(100, 200, 100, 25));
	~interactInputPop0.items = ["Yellow", "Red", "Blue", "Manual",];
	~interactInputPop0.value = 3;
	~interactInputPop0.font_(Font("Monaco", 10));
	~interactInputPop0.action = {arg menu;

	~interactInputChooser0 = menu.value;
	};

// select rest time between Call and Resonse
	~interactRestChooser0 = PopUpMenu(~w5, Rect(250, 175, 25, 25));
	~interactRestChooser0.items = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
	~interactRestChooser0.value = 1;
	~interactRestChooser0.font_(Font("Monaco", 10));
	~interactRestChooser0.action = {arg menu;

	~waitCountAdjusterUpdate0 = (menu.value + 1);

	};

// number of iterations per response task
	~interactTimeChooser0 = PopUpMenu(~w5, Rect(275, 175, 25, 25));
	~interactTimeChooser0.items = ["2", "3", "4", "5", "6", "7", "8", "9"];
	~interactTimeChooser0.value = 2;
	~interactTimeChooser0.font_(Font("Monaco", 10));
	~interactTimeChooser0.action = {arg menu;

	~interactTimeSignature = (menu.value + 2);

	};

// count time of Call
	~interactCounter0 = Routine {
			inf.do({ arg i;

			if((~interactCounterOn == 1),
			{
			~interactCount0 = ~interactCount0 + 1;
			~interactEnvelope = ~interactCount0;
			~interactTimeOut = ~interactTempo0;
			~interactOnsetCalculator = (~interactOnsetCounterOut/~interactEnvelope);
			~interactPitch0 = ~grainPitch0Message0.cpsmidi/50;
			~interactPitch1 = ~grainPitch0Message0.cpsmidi/50;

			});

			if((~interactCounterOn == 0),
			{
			~interactCount0 = 0;
			});

			1.wait

			});
	};

// Set wait time between call and response relative to set value
	~waitCounter0 = Routine {
			inf.do({ arg i;

			if((~interactInput0[~interactInputChooser0] < 5),
			{
			~waitCount0 = ~waitCount0 + 0.5;
			~stopInteractGUI = ~waitCount0;
			});

			if((~interactInput0[~interactInputChooser0] >= 5),
			{
			~waitCount0 = 0;
			~stopInteractGUI = 0;
			});

			0.5.wait

			});
	};

// Response routine
	~interactRoutine0 = Routine {
			inf.do({ arg i, interactPos, interactPitch, interactVol, interactTime0, interactTime1, interactTime2, interactTime3, interactTime4, interactSustain, interactEnd, interactDivision, interactStretch;

// randomly select values relative to respective parameters
			interactPos = rrand(0, ((s.sampleRate * ~interactEnvelope) - (s.sampleRate + (~waitCountAdjuster0 * s.sampleRate)))).round(s.sampleRate/~interactTimeOut);
			interactEnd = rrand(interactPos, ((s.sampleRate * ~interactEnvelope) - (~waitCountAdjuster0 * s.sampleRate))).round(s.sampleRate/~interactTimeOut);
			interactPitch = rrand(~interactPitchOut0, ~interactPitchOut1).round(~interactPitchRound0);
			interactTime0 = [[1/~interactTimeOut, 1], [((1/~interactTimeOut) * 2), 0.5], [((1/~interactTimeOut) * 0.5), 2], [((1/~interactTimeOut) * 1.5), 0.75]].choose;
			interactTime1 = [[1/~interactTimeOut, 1], [1/~interactTimeOut, 1], [((1/~interactTimeOut) * 2), 0.5], [((1/~interactTimeOut) * 0.5), 2], [((1/~interactTimeOut) * 0.5), 2]].choose;
			interactTime2 = [[((1/~interactTimeOut) * 0.5), 2], [((1/~interactTimeOut) * 0.3), 3], [((1/~interactTimeOut) * 0.25), 4], [((1/~interactTimeOut) * 0.5), 2], [((1/~interactTimeOut) * 0.25), 4], [((1/~interactTimeOut) * 0.5), 2]].choose;
			interactTime3 = [[((1/~interactTimeOut) * 0.125), 8], [((1/~interactTimeOut) * 0.125), 4], [((1/~interactTimeOut) * 0.25), 4], [((1/~interactTimeOut) * 0.125), 8]].choose;
			interactTime4 = [[((1/~interactTimeOut) * 4), 0.25], [((1/~interactTimeOut) * 2), 0.5], [((1/~interactTimeOut) * 2), 0.5], [((1/~interactTimeOut) * 4), 0.25], [((1/~interactTimeOut) * 2), 0.5], [((1/~interactTimeOut) * 1.5), 0.75]].choose;
			interactVol = rrand(0.8, 1);
			interactSustain = ~interactEnvelope.max(1);

// if still counting, show 'calculating' window
			if((~interactCounterOn == 1),
			{
			{
			~interactTimeCounter = 0;
			~interactLengthText0.string = "Calculating Phrase Length";
			~interactWaitText0.string = "Calculating Wait Time";
			~interactSpeedText0.string = "Calculating Tempo";
			~interactRestText0.string = "Rest Time is " ++ ~waitCountAdjuster0.asString;
			~waitCountAdjuster0 = ~waitCountAdjusterUpdate0;
			}.defer;
			});

			if((~interactCounterOn == 0) && ((~stopInteractGUI) > (interactSustain + (~interactEnvelope/100.max(0.1) + ~waitCountAdjuster0))),
			{
			{
			~interactTimeCounter = 0;
			~interactLengthText0.string = "";
			~interactWaitText0.string = "Your Turn to Play...";
			~interactSpeedText0.string = "";
			~interactRestText0.string = "";
			}.defer;
			});


// if not counting and response is running, randomly select values
			if((~interactCounterOn == 0) && ((~stopInteractGUI) > (~waitCountAdjuster0/2)) && ((~stopInteractGUI) < (interactSustain + (~interactEnvelope/100.max(0.1)))),
			{
			{

			~candenceOn = 0;

			if(((~interactOnsetCalculator) >= 0) && ((~interactOnsetCalculator) < 25),

			{
			~interactTimeSelector = interactTime4;
			~interactSpeedText0.string = "Sparse";
			});

			if(((~interactOnsetCalculator) >= 25) && ((~interactOnsetCalculator) < 60),

			{
			~interactTimeSelector = interactTime0;
			~interactSpeedText0.string = "Less Sparse";
			});

			if(((~interactOnsetCalculator) >= 60) && ((~interactOnsetCalculator) < 75),

			{
			~interactTimeSelector = interactTime1;
			~interactSpeedText0.string = "Busy";
			});

			if(((~interactOnsetCalculator) >= 85) && ((~interactOnsetCalculator) < 100),

			{
			~interactTimeSelector = interactTime2;
			~interactSpeedText0.string = "More Busy";
			});

			if(((~interactOnsetCalculator) >= 100),

			{
			~interactTimeSelector = interactTime3;
			~interactSpeedText0.string = "Packed";
			});


			~interactStartPos = interactPos;
			~interactFinishPos = interactEnd;

			~interactTimeCounter = (~interactTimeCounter + ~interactTimeAdjust[0]).min(~interactTimeSignature);

			if((~interactTimeCounter < ~interactTimeSignature),
			{

			~interactTimeAdjust = ~interactTimeSelector;


			});

			if((~interactTimeCounter == ~interactTimeSignature),
			{
			~interactTimeCounter = 0;
			~interactTimeAdjust = ~interactTimeSelector;
			~interactTimeCounter = ~interactTimeCounter + ~interactTimeAdjust[0];

			});

			~interactLengthText0.string = "Length of Phrase is " ++ (interactSustain + (~interactTimeAdjust[0]-(~interactTimeAdjust[0]/10))).max(1).round(0.1).asString ++ " seconds";
			~interactWaitText0.string = "Tempo is " ++ (60/(1/~interactTimeOut)).round(0.1).asString ++ " bpm";
			~interactRestText0.string = "";

			}.defer;
			},

			{~candenceOn = 1; ~interactTimeAdjust = [0.01, 0.01];});

// if response is ending, end phrase

			if((~interactCounterOn == 0) && (~candenceOn == 1)
			&& ((~stopInteractGUI) >= (interactSustain + (~interactEnvelope/100.max(0.1))))
			&& ((~stopInteractGUI) <= (interactSustain + (~interactEnvelope/100.max(0.1)) + ~waitCountAdjuster0)),
			{
			{

			~interactSpeedText0.string = "Cadence";

			~interactStartPos = 0;
			~interactFinishPos = s.sampleRate/~interactTimeOut;

			~interactTimeAdjust = [~waitCountAdjuster0, ~waitCountAdjuster0];

			~interactLengthText0.string = "Ending Phrase";
			~interactWaitText0.string = "Tempo is " ++ (60/(1/~interactTimeOut)).round(0.1).asString ++ " bpm";
			~interactRestText0.string = "";

			}.defer;
			});

// send values to interact synth
			~interactSynth.set(
			\triggerOn0, 1,
			\start0, ~interactStartPos,
			\end0, ~interactFinishPos,
			\pitch0, interactPitch,
			\timeStretcher0, ~interactTimeAdjust[1],
			\sustainTime0, interactSustain.max(1) + ~interactTimeAdjust,
			\attackTime0, ~interactEnvelope/100.max(0.1),
			\amplitude0, interactVol,
			\releaseTime0, 0.1,
			);

			~interactTimeAdjust[0].wait;

			});
	};


// set recording of output, relative to value of Call's Loudness
	~interactRoutine1 = Routine {
			inf.do({ arg i;

	if((~waitCount0 < ~waitCountAdjuster0),
	{
		~fxSynth.set(\interactBufferOn0, 1);
		~interactSynth.set(\triggerOn0, 0, \volumeOut0, 0);
		~interactCounterOn = 1;

	if(~interactInputChooser0 <= 2,
	{
		{
		~interactManualButton0.value = 1;
		}.defer;
		});


	if((~interactInput0[~interactInputChooser0] >= 15),

	{
		~interactOnsetCounter = ~interactOnsetCounter + 1;
		~interactOnsetCounterOut = ~interactOnsetCounter;
	});

	});

	if((~waitCount0 >= ~waitCountAdjuster0),
	{
		~fxSynth.set(\interactBufferOn0, 0);
		~interactSynth.set(\triggerOn0, 1, \volumeOut0, 1);
		~interactCounterOn = 0;
		~interactOnsetCounter = 0;

	if(~interactInputChooser0 <= 2,
	{
		{
		~interactManualButton0.value = 0;
		}.defer;
		});
	});

			0.01.wait

			});
	};

// toggle Call and Response process
	~interactButton0 = Button(~w5, Rect(100, 175, 100, 25));
	~interactButton0.states_([["Call and Response Off", Color.black, Color.red],["Call and Response On",
								Color.white, Color.black],]);
	~interactButton0.font_(Font("Monaco", 8));
	~interactButton0.action_({|butt|
		if( butt.value == 0,
			{
			~interactWindow0.close;
			~interactRoutine0.stop;
			~interactRoutine1.stop;
			~interactCounter0.stop;
			~waitCounter0.stop;
			~fxSynth.set(\interactBufferOn0, 0);
			~interactSynth.set(\triggerOn0, 0, \volumeOut0, 0);
			~interactWindowOn = 0;
			});
		if( butt.value == 1,
			{
			~interactWindow0 = Window("Interaction Display", Rect(300, 400, 300, 200));
			~interactWindow0.alwaysOnTop = true;
			~interactWindow0.userCanClose = false;
			~interactWindow0.front;
			~interactLengthText0 = StaticText(~interactWindow0, Rect(0, 0, 300, 25));
			~interactLengthText0.font_(Font("Monaco", 14));
			~interactLengthText0.align = \center;
			~interactWaitText0 = StaticText(~interactWindow0, Rect(0, 25, 300, 25));
			~interactWaitText0.font_(Font("Monaco", 14));
			~interactWaitText0.align = \center;
			~interactSpeedText0 = StaticText(~interactWindow0, Rect(0, 50, 300, 25));
			~interactSpeedText0.font_(Font("Monaco", 14));
			~interactSpeedText0.align = \center;
			~interactRestText0 = StaticText(~interactWindow0, Rect(0, 75, 300, 25));
			~interactRestText0.font_(Font("Monaco", 14));
			~interactRestText0.align = \center;
			~interactManualButton0 = Button(~interactWindow0, Rect(0, 100, 300, 100));
			~interactManualButton0.states_([["Response",Color.black, Color.green], ["Call", Color.black, Color.red],]);
			~interactManualButton0.font_(Font("Monaco", 20));
			~interactManualButton0.action_({|butt|
				if( butt.value == 0,
				{~manualInteract0 = 0
				});
				if( butt.value == 1,
				{~manualInteract0 = 16
				});
			});
			~interactWindowOn = 1;
			~interactRoutine0.reset;
			~interactRoutine0.play;
			~interactRoutine1.reset;
			~interactRoutine1.play;
			~interactCounter0.reset;
			~interactCounter0.play;
			~waitCounter0.reset;
			~waitCounter0.play;
			});
			});

// toggle panning of output mix
	~grainSlicer0 = Button(~w5, Rect(200, 50, 100, 25));
	~grainSlicer0.font_(Font("Monaco", 10));
	~grainSlicer0.states_([
					["Auto Grain Off",Color.white,Color.gray],
					["Auto Grain On",Color.gray,Color.white],
							]);

	~grainSlicer0.action_({arg butt;
	if ( butt.value == 0,
	{~fxSynth.set(\grainChooser, 0);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Auto Grain Off ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~grainSlicer0.valueAction = " ++ ~grainSlicer0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);				},
	{~fxSynth.set(\grainChooser, 1);
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ ~clockOut ++ " Auto Grain On ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~saveText.string_(" \n\n " " if(
	~clockGUI == " ++ ~clockGUI ++  "," ++
	"{{ ~grainSlicer0.valueAction = " ++ ~grainSlicer0.value.asString ++  " }.defer;}); ",
	(~saveText.string.size), (~saveText.string.size));
	~saveText.selectLine(~saveText.string.size);				}
	)
	});

// set window size of Genesis to default of 1920/1200
	~heightScaler0 = 1;
	~widthScaler0 = 1;
	~textEditor.background = Color.new255(110, 109, 110);

	~resolutionHeightText0 = TextField(~w6, Rect(25, 275, 50, 25));
	~resolutionHeightText0.string = "1920";
	~resolutionHeightText0.action = {arg field;
		 ~resolutionHeight = field.value;

		if(~resolutionHeight != 1920,
		{~heightScaler0 = 1920/field.value.asInteger});
		};

// set ALL objects to scaled value, relative to input video resolution
	~resolutionWidthText0 = TextField(~w6, Rect(75, 275, 50, 25));
	~resolutionWidthText0.string = "1200";
	~resolutionWidthText0.action = {arg field;
		 ~resolutionWidth = field.value;

		if(~resolutionWidth != 1200,
		{~widthScaler0 = 1200/field.value.asInteger});

	~visualResolutionWidth0 = 960/~widthScaler0;
	~visualResolutionHeight0 = 600/~heightScaler0;

	~w1.bounds = Rect(0, 836/~heightScaler0, 1920/~widthScaler0, 320/~heightScaler0);
	~w5.bounds = Rect(((1920/6)*3)/~widthScaler0, 0, (1920/2)/~widthScaler0, 316/~heightScaler0);
	~w6.bounds = Rect(((1920/6)*1.5)/~widthScaler0, 0, (1920/4)/~widthScaler0, 316/~heightScaler0);
	~w7.bounds = Rect(0, 686/~heightScaler0, 1920/~widthScaler0, 150/~heightScaler0);
	~w8.bounds = Rect(0, 316/~heightScaler0, 1920/~widthScaler0, 370/~heightScaler0);
//	~sampleWindow0.bounds = Rect(25/~widthScaler0, 908/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-100)/~heightScaler0);
//	~sampleWindow1.bounds = Rect((640+25)/~widthScaler0, 908/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-100)/~heightScaler0);
//	~sampleWindow2.bounds = Rect((1280+25)/~widthScaler0, 908/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-100)/~heightScaler0);
	~textEditor.bounds = Rect(0, 0, (1920/4)/~widthScaler0, 316/~heightScaler0);
	~triggerButtonOn0.bounds = Rect(((1280+25) + 195)/~widthScaler0, 150/~heightScaler0,  50/~widthScaler0, 50/~heightScaler0);
	~triggerButtonOn1.bounds = Rect(((1280+25) + 295)/~widthScaler0, 150/~heightScaler0, 50/~widthScaler0, 50/~heightScaler0);
	~triggerButtonOn2.bounds = Rect(((1280+25) + 395)/~widthScaler0, 150/~heightScaler0, 50/~widthScaler0, 50/~heightScaler0);
	~samplePathButton0.bounds = Rect(25/~widthScaler0, 0, ((1920/3)-50)/~widthScaler0, 26/~heightScaler0);
	~loop0Button0.bounds = Rect(25/~widthScaler0, (300-26)/~heightScaler0, (((1920/3)/2)-25)/~widthScaler0, 26/~heightScaler0);
	~triggerButton0.bounds = Rect((25 + (((1920/3)/2)-25))/~widthScaler0, (300-26)/~heightScaler0, (((1920/3)/2)-25)/~widthScaler0, 26/~heightScaler0);
	~samplePathButton1.bounds = Rect((640+25)/~widthScaler0, 0, ((1920/3)-50)/~widthScaler0, 26/~heightScaler0);
	~loop1Button0.bounds = Rect((640+25)/~widthScaler0, (300-26)/~heightScaler0, ((1920/3/2)-25)/~widthScaler0, 26/~heightScaler0);
	~triggerButton1.bounds = Rect(((640+25) + ((1920/3/2)-25))/~widthScaler0, (300-26)/~heightScaler0, ((1920/3/2)-25)/~widthScaler0, 26/~heightScaler0);
	~samplePathButton2.bounds = Rect((1280+25)/~widthScaler0, 0, ((1920/3)-50)/~widthScaler0, 26/~heightScaler0);
	~loop2Button0.bounds = Rect((1280+25)/~widthScaler0, (300-26)/~heightScaler0, ((1920/3/2)-25)/~widthScaler0, 26/~heightScaler0);
	~triggerButton2.bounds = Rect(((1280+25) + ((1920/3/2)-25))/~widthScaler0, (300-26)/~heightScaler0, ((1920/3/2)-25)/~widthScaler0, 26/~heightScaler0);
	~loopChoose0.bounds = Rect(25/~widthScaler0, (300)/~heightScaler0, 590/~widthScaler0, 20/~heightScaler0);
	~loopChoose1.bounds = Rect((1920/3 + 25)/~widthScaler0, (300)/~heightScaler0, 590/~widthScaler0, 20/~heightScaler0);
	~loopChoose2.bounds = Rect((1920/1.5 +25)/~widthScaler0, (300)/~heightScaler0, 590/~widthScaler0, 20/~heightScaler0);
	~osc0LevelSlider0.view.bounds = Rect(((1920/3)-25)/~widthScaler0, 0, 25/~widthScaler0, 300/~heightScaler0);
	~osc1LevelSlider0.view.bounds = Rect((((1920/3)-12.5)*2)/~widthScaler0, 0, 25/~widthScaler0, 300/~heightScaler0);
	~osc2LevelSlider0.view.bounds = Rect((((1920/3)-9)*3)/~widthScaler0, 0, 25/~widthScaler0, 300/~heightScaler0);
	~zoom0Slider0.view.bounds = Rect(0, 0, 26, 300);
	~scroll0Slider0.view.bounds = Rect(0, (300-52)/~heightScaler0, ((1920/3)-26)/~widthScaler0, 26/~heightScaler0);
	~zoom1Slider0.view.bounds = Rect(640/~widthScaler0, 0, 26/~widthScaler0, 300/~heightScaler0);
	~scroll1Slider0.view.bounds = Rect(640/~widthScaler0, (300-52)/~heightScaler0, ((1920/3)-26)/~widthScaler0, 26/~heightScaler0);
	~zoom2Slider0.view.bounds = Rect(1280/~widthScaler0, 0, 26/~widthScaler0, 300/~heightScaler0);
	~scroll2Slider0.view.bounds = Rect(1280/~widthScaler0, (300-52)/~heightScaler0, ((1920/3)-26)/~widthScaler0, 26/~heightScaler0);
	~oscData0Slider0.bounds = Rect(26/~widthScaler0, 26/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-78)/~heightScaler0);
	~oscData1Slider0.bounds = Rect(((640)+25)/~widthScaler0, 26/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-78)/~heightScaler0);
	~oscData2Slider0.bounds = Rect((1280+25)/~widthScaler0, 26/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-78)/~heightScaler0);
	~sampleViewer0.bounds = Rect(26/~widthScaler0, 26/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-100)/~heightScaler0);
	~sampleViewer1.bounds = Rect(((640)+25)/~widthScaler0, 26/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-100)/~heightScaler0);
	~sampleViewer2.bounds = Rect((1280+25)/~widthScaler0, 26/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-100)/~heightScaler0);
	~attackText0[23].bounds = Rect(26/~widthScaler0, 26/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-78)/~heightScaler0);
	~onText0.bounds = Rect(((640)+25)/~widthScaler0, 26/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-78)/~heightScaler0);
	~attackText0[24].bounds = Rect((1280+25)/~widthScaler0, 26/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-78)/~heightScaler0);
	~synthText0.bounds = Rect(26/~widthScaler0, 60/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-138)/~heightScaler0);
	~synthText1.bounds = Rect(((640)+25)/~widthScaler0, 60/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-138)/~heightScaler0);
	~synthText2.bounds = Rect((1280+25)/~widthScaler0, 60/~heightScaler0, ((1920/3)-50)/~widthScaler0, (300-138)/~heightScaler0);
	~attackText0[0].bounds = Rect((((1920/3)/4)*2 + 10)/~widthScaler0, 123/~heightScaler0, 92/~widthScaler0, 120/~heightScaler0);
	~attackText0[1].bounds = Rect((((1920/3)/4)*2 + 10)/~widthScaler0, 123/~heightScaler0, 120/~widthScaler0, 120/~heightScaler0);
	~attackText0[2].bounds = Rect((((1920/3)/4)*6 + 10)/~widthScaler0, 123/~heightScaler0, 92/~widthScaler0, 120/~heightScaler0);
	~attackText0[3].bounds = Rect((((1920/3)/4)*6 + 10)/~widthScaler0, 123/~heightScaler0, 120/~widthScaler0, 120/~heightScaler0);
	~attackText0[11].bounds = Rect((((1920/3)/4)*2 + 10)/~widthScaler0, 0, 120/~widthScaler0, 120/~heightScaler0);
	~attackText0[4].bounds = Rect((((1920/3)/4)*6 + 10)/~widthScaler0, 0, 120/~widthScaler0, 120/~heightScaler0);
	~attackText0[5].bounds = Rect((10)/~widthScaler0, 240/~heightScaler0, 120/~widthScaler0, 123/~heightScaler0);
	~attackText0[6].bounds = Rect((((1920/3)/4)*4 + 10)/~widthScaler0, 246/~heightScaler0, 120/~widthScaler0, 120/~heightScaler0);
	~attackText0[7].bounds = Rect(((((1920/3)/4)*10 + 10))/~widthScaler0, 0, 120/~widthScaler0, 120/~heightScaler0);
	~attackText0[28].bounds = Rect(((((1920/3)/4)*10 + 10))/~widthScaler0, 123/~heightScaler0, 92/~widthScaler0, 120/~heightScaler0);
	~attackText0[29].bounds = Rect(((((1920/3)/4)*10 + 10))/~widthScaler0, 123/~heightScaler0, 100/~widthScaler0, 120/~heightScaler0);
	~attackText0[8].bounds = Rect((((1920/3)/4)*8 + 10)/~widthScaler0, 246/~heightScaler0, 120/~widthScaler0, 120/~heightScaler0);
	~attackText0[9].bounds = Rect((10)/~widthScaler0, 123/~heightScaler0, 120/~widthScaler0, 120/~heightScaler0);
	~attackText0[10].bounds = Rect((((1920/3)/4)*4 + 10)/~widthScaler0, 123/~heightScaler0, 120/~widthScaler0, 120/~heightScaler0);
	~attackText0[12].bounds = Rect((((1920/3)/4)*8 + 10)/~widthScaler0, 123/~heightScaler0, 120/~widthScaler0, 120/~heightScaler0);
	~attackText0[13].bounds = Rect((((1920/3)/4)*2 + 10)/~widthScaler0, 246/~heightScaler0, 120/~widthScaler0, 120/~heightScaler0);
	~attackText0[14].bounds = Rect((((1920/3)/4)*6 + 10)/~widthScaler0, 246/~heightScaler0, 120/~widthScaler0, 120/~heightScaler0);
	~attackText0[15].bounds = Rect((((1920/3)/4)*10 + 10)/~widthScaler0, 246/~heightScaler0, 120/~widthScaler0, 120/~heightScaler0);
	~attackText0[16].bounds = Rect((10)/~widthScaler0, 0, 120, 120/~heightScaler0);
	~attackText0[17].bounds = Rect((((1920/3)/4)*4 + 10)/~widthScaler0, 0, 120/~widthScaler0, 120/~heightScaler0);
	~attackText0[18].bounds = Rect((((1920/3)/4)*8 + 10)/~widthScaler0, 0, 120/~widthScaler0, 120/~heightScaler0);
	~grainAttack0Slider.bounds = Rect((((1920/3)/4)*2)/~widthScaler0, 123/~heightScaler0, (1920/12)/~widthScaler0, 120/~heightScaler0);
	~grainRelease0Slider.bounds = Rect((((1920/3)/4)*3)/~widthScaler0, 123/~heightScaler0, (1920/12)/~widthScaler0, 120/~heightScaler0);
	~grainAmplitude0Slider.bounds = Rect((((1920/3)/4)*2)/~widthScaler0, 0, (1920/6)/~widthScaler0, 120/~heightScaler0);
	~grainAttack1Slider.bounds = Rect((((1920/3)/4)*6)/~widthScaler0, 123/~heightScaler0, (1920/12)/~widthScaler0, 120/~heightScaler0);
	~grainRelease1Slider.bounds = Rect((((1920/3)/4)*7)/~widthScaler0, 123/~heightScaler0, (1920/12)/~widthScaler0, 120/~heightScaler0);
	~grainAmplitude1Slider.bounds = Rect((((1920/3)/4)*6)/~widthScaler0, 0, (1920/6)/~widthScaler0, 120/~heightScaler0);
	~grainAmplitude2Slider.bounds = Rect((((1920/3)/4)*10)/~widthScaler0, 0, ((1920/6)-5)/~widthScaler0, 120/~heightScaler0);
	~grainAttack2Slider.bounds = Rect((((1920/3)/4)*10)/~widthScaler0, 123/~heightScaler0, (1920/12)/~widthScaler0, 120/~heightScaler0);
	~grainRelease2Slider.bounds = Rect((((1920/3)/4)*11)/~widthScaler0, 123/~heightScaler0, ((1920/12)-5)/~widthScaler0, 120/~heightScaler0);
	~onsetThresholdSlider0.bounds = Rect(0, 123/~heightScaler0, (1920/6)/~widthScaler0, 120/~heightScaler0);
	~onsetThresholdSlider1.bounds = Rect((((1920/3)/4)*4)/~widthScaler0, 123/~heightScaler0, (1920/6)/~widthScaler0, 120/~heightScaler0);
	~onsetThresholdSlider2.bounds = Rect((((1920/3)/4)*8)/~widthScaler0, 123/~heightScaler0, (1920/6)/~widthScaler0, 120/~heightScaler0);
	~onsetDurationSlider0.bounds = Rect(0, 246/~heightScaler0, (1920/6)/~widthScaler0, 120/~heightScaler0);
	~onsetDurationSlider1.bounds = Rect((((1920/3)/4)*4)/~widthScaler0, 246/~heightScaler0, (1920/6)/~widthScaler0, 120/~heightScaler0);
	~feedbackDurationSlider0.bounds = Rect((((1920/3)/4)*8)/~widthScaler0, 246/~heightScaler0, (1920/6)/~widthScaler0, 120/~heightScaler0);
	~filterFreqSlider0.bounds = Rect(0, 0, (1920/6)/~widthScaler0, 120/~heightScaler0);
	~filterFreqSlider1.bounds = Rect((((1920/3)/4)*4)/~widthScaler0, 0, (1920/6)/~widthScaler0, 120/~heightScaler0);
	~filterFreqSlider2.bounds = Rect((((1920/3)/4)*8)/~widthScaler0, 0, (1920/6)/~widthScaler0, 120/~heightScaler0);
	~pitch0Slider0.bounds = Rect((((1920/3)/4)*2)/~widthScaler0, 246/~heightScaler0, (1920/6)/~widthScaler0, 120/~heightScaler0);
 	~pitch1Slider0.bounds = Rect((((1920/3)/4)*6)/~widthScaler0, 246/~heightScaler0, (1920/6)/~widthScaler0, 120/~heightScaler0);
	~pitch2Slider0.bounds = Rect((((1920/3)/4)*10)/~widthScaler0, 246/~heightScaler0, (1920/6)/~widthScaler0, 120/~heightScaler0);
	~dryLevelSlider0.view.bounds = Rect(25/~widthScaler0, 25/~heightScaler0, 25/~widthScaler0, 250/~heightScaler0);
	~mainOutSlider0.view.bounds = Rect(425/~widthScaler0, 25/~heightScaler0, 25/~widthScaler0, 250/~heightScaler0);
	~fxLevelSlider0.view.bounds = Rect(50/~widthScaler0, 25/~heightScaler0, 25/~widthScaler0, 250/~heightScaler0);
	~grainLevel0Slider.view.bounds = Rect(75/~widthScaler0, 25/~heightScaler0, 25/~widthScaler0, 250/~heightScaler0);
	~filterSlider0.view.bounds = Rect(100/~widthScaler0, 25/~heightScaler0, 25/~widthScaler0, 250/~heightScaler0);
	~grainLevel1Slider.view.bounds = Rect(125/~widthScaler0, 25/~heightScaler0, 25/~widthScaler0, 250/~heightScaler0);
	~filterSlider1.view.bounds = Rect(150/~widthScaler0, 25/~heightScaler0, 25/~widthScaler0, 250/~heightScaler0);
	~grainLevel2Slider.view.bounds = Rect(175/~widthScaler0, 25/~heightScaler0, 25/~widthScaler0, 250/~heightScaler0);
	~filterSlider2.view.bounds = Rect(200/~widthScaler0, 25/~heightScaler0, 25/~widthScaler0, 250/~heightScaler0);
	~micLevelSlider0.view.bounds = Rect(450/~widthScaler0, 25/~heightScaler0, 25/~widthScaler0, 250/~heightScaler0);
	~filterOn0.bounds = Rect(325/~widthScaler0, 50/~heightScaler0, 100/~widthScaler0, 50/~heightScaler0);
	~filterOn1.bounds = Rect(325/~widthScaler0, 100/~heightScaler0, 100/~widthScaler0, 50/~heightScaler0);
	~filterOn2.bounds = Rect(325/~widthScaler0, 150/~heightScaler0, 100/~widthScaler0, 50/~heightScaler0);
	~clockText.bounds = Rect(25/~widthScaler0, 0, 200/~widthScaler0, 25/~heightScaler0);
	~clockTextDivider.bounds = Rect(25/~widthScaler0, 0, 200/~widthScaler0, 25/~heightScaler0);
	~clockStart.bounds = Rect(225/~widthScaler0, 0, 100/~widthScaler0, 25/~heightScaler0);
	~clockStop.bounds = Rect(325/~widthScaler0, 0, 50/~widthScaler0, 25/~heightScaler0);
	~clockSyncIn.bounds = Rect(375/~widthScaler0, 0, 50/~widthScaler0, 25/~heightScaler0);
	~textEditorButton.bounds = Rect(125/~widthScaler0, 275/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~inputSwitch0.bounds = Rect(225/~widthScaler0, 50/~heightScaler0, 100/~widthScaler0, 50/~heightScaler0);
	~inputSwitch1.bounds = Rect(225/~widthScaler0, 100/~heightScaler0, 100/~widthScaler0, 50/~heightScaler0);
	~inputSwitch2.bounds = Rect(225/~widthScaler0, 150/~heightScaler0, 100/~widthScaler0, 50/~heightScaler0);
	~recordSwitch0.bounds = Rect(125/~widthScaler0, 25/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~allocateTask0.bounds = Rect(325/~widthScaler0, 225/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~routineName0.bounds = Rect(225/~widthScaler0, 250/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~recordLengthInput0.bounds = Rect(75/~widthScaler0, 25/~heightScaler0, 50/~widthScaler0, 25/~heightScaler0);
	~grainLengthInput0.bounds = Rect(425/~widthScaler0, 25/~heightScaler0, 50/~widthScaler0, 25/~heightScaler0);
	~quickLoadSelector0.bounds = Rect((225 + (200/2))/~widthScaler0, 25/~heightScaler0, (200/2)/~widthScaler0, 25/~heightScaler0);
	~quickLoad0.bounds = Rect(225/~widthScaler0, 25/~heightScaler0, (200/2)/~widthScaler0, 25/~heightScaler0);
	~clockMinutesAdjust.bounds = Rect(425/~widthScaler0, 0, 25/~widthScaler0, 25/~heightScaler0);
	~clockSecondsAdjust.bounds = Rect(450/~widthScaler0, 0, 25/~widthScaler0, 25/~heightScaler0);
	~resolutionHeightText0.bounds = Rect(25/~widthScaler0, 275/~heightScaler0, 50/~widthScaler0, 25/~heightScaler0);
	~resolutionWidthText0.bounds = Rect(75/~widthScaler0, 275/~heightScaler0, 50/~widthScaler0, 25/~heightScaler0);
	~newRoutineButton0.bounds = Rect(225/~widthScaler0, 225/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~textEditorNewButton0.bounds = Rect(225/~widthScaler0, 200/~heightScaler0, 200/~widthScaler0, 25/~heightScaler0);
	~editButton.bounds = Rect(325/~widthScaler0, 250/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~ipView.bounds = Rect(225/~widthScaler0, 266/~heightScaler0, 200/~widthScaler0, 50/~heightScaler0);
	~tickButton0[0].bounds = Rect(0+(0*(1920/3)/13)/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton0[1].bounds = Rect(0+(1*(1920/3)/13)/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton0[2].bounds = Rect(0+(2*(1920/3)/13)/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton0[3].bounds = Rect(0+(3*(1920/3)/13)/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton0[4].bounds = Rect(0+(4*(1920/3)/13)/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton0[5].bounds = Rect(0+(5*(1920/3)/13)/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton0[6].bounds = Rect(0+(6*(1920/3)/13)/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton0[7].bounds = Rect(0+(7*(1920/3)/13)/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton0[8].bounds = Rect(0+(8*(1920/3)/13)/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton0[9].bounds = Rect(0+(9*(1920/3)/13)/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton0[10].bounds = Rect(0+(10*(1920/3)/13)/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton0[11].bounds = Rect(0+(11*(1920/3)/13)/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton0[12].bounds = Rect(0+(12*(1920/3)/13)/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton1[0].bounds = Rect(0+((1920/6)*2 + (0*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton1[1].bounds = Rect(0+((1920/6)*2 + (1*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton1[2].bounds = Rect(0+((1920/6)*2 + (2*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton1[3].bounds = Rect(0+((1920/6)*2 + (3*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton1[4].bounds = Rect(0+((1920/6)*2 + (4*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton1[5].bounds = Rect(0+((1920/6)*2 + (5*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton1[6].bounds = Rect(0+((1920/6)*2 + (6*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton1[7].bounds = Rect(0+((1920/6)*2 + (7*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton1[8].bounds = Rect(0+((1920/6)*2 + (8*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton1[9].bounds = Rect(0+((1920/6)*2 + (9*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton1[10].bounds = Rect(0+((1920/6)*2 + (10*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton1[11].bounds = Rect(0+((1920/6)*2 + (11*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton1[12].bounds = Rect(0+((1920/6)*2 + (12*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton2[0].bounds = Rect(0+((1920/6)*4 +(0*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton2[1].bounds = Rect(0+((1920/6)*4 +(1*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton2[2].bounds = Rect(0+((1920/6)*4 +(2*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton2[3].bounds = Rect(0+((1920/6)*4 +(3*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton2[4].bounds = Rect(0+((1920/6)*4 +(4*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton2[5].bounds = Rect(0+((1920/6)*4 +(5*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton2[6].bounds = Rect(0+((1920/6)*4 +(6*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton2[7].bounds = Rect(0+((1920/6)*4 +(7*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton2[8].bounds = Rect(0+((1920/6)*4 +(8*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton2[9].bounds = Rect(0+((1920/6)*4 +(9*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton2[10].bounds = Rect(0+((1920/6)*4 +(10*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton2[11].bounds = Rect(0+((1920/6)*4 +(11*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~tickButton2[12].bounds = Rect(0+((1920/6)*4 +(12*(1920/3)/13))/~widthScaler0, 32/~heightScaler0, ((1920/3)/20)/~widthScaler0, 12.5/~heightScaler0);
	~pitchView0.bounds = Rect((((1920/3)/4)*1.7)/~widthScaler0, 40/~heightScaler0, (1920/12)/~widthScaler0, 90/~heightScaler0);
	~pitchView1.bounds = Rect((((1920/3)/4)*5.7)/~widthScaler0, 40/~heightScaler0, (1920/12)/~widthScaler0, 90/~heightScaler0);
	~grainPitch0View0.bounds = Rect((((1920/3)/4)*9.7)/~widthScaler0, 40/~heightScaler0, (1920/12)/~widthScaler0, 90/~heightScaler0);
	~filterTrackerSlider0[0].view.bounds = Rect(((5) + ((((1920/3))/26) * 0))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider0[1].view.bounds = Rect(((5) + ((((1920/3))/26) * 1))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider0[2].view.bounds = Rect(((5) + ((((1920/3))/26) * 2))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider0[3].view.bounds = Rect(((5) + ((((1920/3))/26) * 3))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider0[4].view.bounds = Rect(((5) + ((((1920/3))/26) * 4))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider0[5].view.bounds = Rect(((5) + ((((1920/3))/26) * 5))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider0[6].view.bounds = Rect(((5) + ((((1920/3))/26) * 6))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider0[7].view.bounds = Rect(((5) + ((((1920/3))/26) * 7))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider0[8].view.bounds = Rect(((5) + ((((1920/3))/26) * 8))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider0[9].view.bounds = Rect(((5) + ((((1920/3))/26) * 9))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider0[10].view.bounds = Rect(((5) + ((((1920/3))/26) * 10))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider0[11].view.bounds = Rect(((5) + ((((1920/3))/26) * 11))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider0[12].view.bounds = Rect(((5) + ((((1920/3))/26) * 12))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider1[0].view.bounds = Rect((((1920/3 + 5)) + ((((1920/3))/26) * 0))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider1[1].view.bounds = Rect((((1920/3 + 5)) + ((((1920/3))/26) * 1))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider1[2].view.bounds = Rect((((1920/3 + 5)) + ((((1920/3))/26) * 2))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider1[3].view.bounds = Rect((((1920/3 + 5)) + ((((1920/3))/26) * 3))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider1[4].view.bounds = Rect((((1920/3 + 5)) + ((((1920/3))/26) * 4))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider1[5].view.bounds = Rect((((1920/3 + 5)) + ((((1920/3))/26) * 5))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider1[6].view.bounds = Rect((((1920/3 + 5)) + ((((1920/3))/26) * 6))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider1[7].view.bounds = Rect((((1920/3 + 5)) + ((((1920/3))/26) * 7))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider1[8].view.bounds = Rect((((1920/3 + 5)) + ((((1920/3))/26) * 8))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider1[9].view.bounds = Rect((((1920/3 + 5)) + ((((1920/3))/26) * 9))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider1[10].view.bounds = Rect((((1920/3 + 5)) + ((((1920/3))/26) * 10))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider1[11].view.bounds = Rect((((1920/3 + 5)) + ((((1920/3))/26) * 11))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider1[12].view.bounds = Rect((((1920/3 + 5)) + ((((1920/3))/26) * 12))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider2[0].view.bounds = Rect((((1920/3 + 3.5)*2) + ((((1920/3))/26) * 0))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider2[1].view.bounds = Rect((((1920/3 + 3.5)*2) + ((((1920/3))/26) * 1))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider2[2].view.bounds = Rect((((1920/3 + 3.5)*2) + ((((1920/3))/26) * 2))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider2[3].view.bounds = Rect((((1920/3 + 3.5)*2) + ((((1920/3))/26) * 3))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider2[4].view.bounds = Rect((((1920/3 + 3.5)*2) + ((((1920/3))/26) * 4))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider2[5].view.bounds = Rect((((1920/3 + 3.5)*2) + ((((1920/3))/26) * 5))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider2[6].view.bounds = Rect((((1920/3 + 3.5)*2) + ((((1920/3))/26) * 6))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider2[7].view.bounds = Rect((((1920/3 + 3.5)*2) + ((((1920/3))/26) * 7))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider2[8].view.bounds = Rect((((1920/3 + 3.5)*2) + ((((1920/3))/26) * 8))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider2[9].view.bounds = Rect((((1920/3 + 3.5)*2) + ((((1920/3))/26) * 9))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider2[10].view.bounds = Rect((((1920/3 + 3.5)*2) + ((((1920/3))/26) * 10))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider2[11].view.bounds = Rect((((1920/3 + 3.5)*2) + ((((1920/3))/26) * 11))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~filterTrackerSlider2[12].view.bounds = Rect((((1920/3 + 3.5)*2) + ((((1920/3))/26) * 12))/~widthScaler0 , 48/~heightScaler0, (((1920/3)/2)/21)/~widthScaler0, 100/~heightScaler0);
	~tempo0Textbox0.bounds = Rect(321/~widthScaler0, 117/~heightScaler0, 80/~widthScaler0, 25/~heightScaler0);
	~tempo1Textbox0.bounds = Rect((1920/3 + 321)/~widthScaler0, 117/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~tempo2Textbox0.bounds = Rect((1920/3 * 2 + 321)/~widthScaler0, 117/~heightScaler0, 80/~widthScaler0, 25/~heightScaler0);
	~osc0PitchSlider0 .view.bounds = Rect(400/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~grainLengthSlider0.view.bounds = Rect(440/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~osc0StretchSlider0.view.bounds = Rect(480/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~samplerateSlider0.view.bounds = Rect(520/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~trackingUpdateSlider1.view.bounds = Rect(560/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~filterAdjuster0.view.bounds = Rect(600/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~osc1PitchSlider0.view.bounds = Rect((1920/3 + 400)/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~grainLengthSlider1.view.bounds = Rect((1920/3 + 440)/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~osc1StretchSlider0.view.bounds = Rect((1920/3 + 480)/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~samplerateSlider1.view.bounds = Rect((1920/3 + 520)/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~trackingUpdateSlider2.view.bounds = Rect((1920/3 + 560)/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~filterAdjuster1.view.bounds = Rect((1920/3 + 600)/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~osc2PitchSlider0.view.bounds = Rect((1920/3 * 2 + 400)/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~grainLengthSlider2.view.bounds = Rect((1920/3 * 2 + 440)/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~osc2StretchSlider0.view.bounds = Rect((1920/3 * 2 + 480)/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~samplerateSlider2.view.bounds = Rect((1920/3 * 2 + 520)/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~trackingUpdateSlider3.view.bounds = Rect((1920/3 * 2 + 560)/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~filterAdjuster2.view.bounds = Rect((1920/3 * 2 + 600)/~widthScaler0, 26/~heightScaler0, 30/~widthScaler0, 120/~heightScaler0);
	~panKnob0[0].bounds = Rect((0*(1920/3.25)/13)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob0[1].bounds = Rect((1*(1920/3.25)/13)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob0[2].bounds = Rect((2*(1920/3.25)/13)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob0[3].bounds = Rect((3*(1920/3.25)/13)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob0[4].bounds = Rect((4*(1920/3.25)/13)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob0[5].bounds = Rect((5*(1920/3.25)/13)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob0[6].bounds = Rect((6*(1920/3.25)/13)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob0[7].bounds = Rect((7*(1920/3.25)/13)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob0[8].bounds = Rect((8*(1920/3.25)/13)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob0[9].bounds = Rect((9*(1920/3.25)/13)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob0[10].bounds = Rect((10*(1920/3.25)/13)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob0[11].bounds = Rect((11*(1920/3.25)/13)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob0[12].bounds = Rect((12*(1920/3.25)/13)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob1[0].bounds = Rect((0*((1920/3.25)/13)+640)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob1[1].bounds = Rect((1*((1920/3.25)/13)+640)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob1[2].bounds = Rect((2*((1920/3.25)/13)+640)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob1[3].bounds = Rect((3*((1920/3.25)/13)+640)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob1[4].bounds = Rect((4*((1920/3.25)/13)+640)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob1[5].bounds = Rect((5*((1920/3.25)/13)+640)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob1[6].bounds = Rect((6*((1920/3.25)/13)+640)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob1[7].bounds = Rect((7*((1920/3.25)/13)+640)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob1[8].bounds = Rect((8*((1920/3.25)/13)+640)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob1[9].bounds = Rect((9*((1920/3.25)/13)+640)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob1[10].bounds = Rect((10*((1920/3.25)/13)+640)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob1[11].bounds = Rect((11*((1920/3.25)/13)+640)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob1[12].bounds = Rect((12*((1920/3.25)/13)+640)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob2[0].bounds = Rect((0*((1920/3.25)/13)+1280)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob2[1].bounds = Rect((1*((1920/3.25)/13)+1280)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob2[2].bounds = Rect((2*((1920/3.25)/13)+1280)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob2[3].bounds = Rect((3*((1920/3.25)/13)+1280)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob2[4].bounds = Rect((4*((1920/3.25)/13)+1280)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob2[5].bounds = Rect((5*((1920/3.25)/13)+1280)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob2[6].bounds = Rect((6*((1920/3.25)/13)+1280)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob2[7].bounds = Rect((7*((1920/3.25)/13)+1280)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob2[8].bounds = Rect((8*((1920/3.25)/13)+1280)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob2[9].bounds = Rect((9*((1920/3.25)/13)+1280)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob2[10].bounds = Rect((10*((1920/3.25)/13)+1280)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob2[11].bounds = Rect((11*((1920/3.25)/13)+1280)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~panKnob2[12].bounds = Rect((12*((1920/3.25)/13)+1280)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, ((1920/3)/20)/~heightScaler0);
	~attackText0[19].bounds = Rect(825/~widthScaler0, 200/~heightScaler0, 60/~widthScaler0, 50/~heightScaler0);
	~attackText0[20].bounds = Rect(825/~widthScaler0, 230/~heightScaler0, 60/~widthScaler0, 50/~heightScaler0);
	~attackText0[21].bounds = Rect(920/~widthScaler0, 200/~heightScaler0, 25/~widthScaler0, 50/~heightScaler0);
	~attackText0[22].bounds = Rect(920/~widthScaler0, 230/~heightScaler0, 25/~widthScaler0, 50/~heightScaler0);
	~attackText0[27].bounds = Rect(733/~widthScaler0, 210/~heightScaler0, 100/~widthScaler0, 35/~heightScaler0);
	~scaleViewer0.bounds = Rect(0, 0, (1920/2)/~widthScaler0, 300/~heightScaler0);
	~scaleViewer1.bounds = Rect(0, 0, (1920/2)/~widthScaler0, 300/~heightScaler0);
	~dataChooserPopUp0.bounds = Rect(825/~widthScaler0, 0, 115/~widthScaler0, 100/~heightScaler0);
	~dataChooserPopUp1.bounds = Rect(825/~widthScaler0, 100/~heightScaler0, 115/~widthScaler0, 100/~heightScaler0);
	~revButton0[0].bounds = Rect(600/~widthScaler0, 0, 100/~widthScaler0, 25/~heightScaler0);
	~revButton0[1].bounds = Rect(600/~widthScaler0, 37.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~revButton0[2].bounds = Rect(600/~widthScaler0, 75/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~revButton0[3].bounds = Rect(600/~widthScaler0, 112.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~revButton0[4].bounds = Rect(600/~widthScaler0, 150/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~revButton0[5].bounds = Rect(600/~widthScaler0, 187.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~revButton0[6].bounds = Rect(600/~widthScaler0, 225/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~revChooserPop0[0].bounds = Rect(700/~widthScaler0, 0, 100/~widthScaler0, 25/~heightScaler0);
	~revChooserPop0[1].bounds = Rect(700/~widthScaler0, 37.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~revChooserPop0[2].bounds = Rect(700/~widthScaler0, 75/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~revChooserPop0[3].bounds = Rect(700/~widthScaler0, 112.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~revChooserPop0[4].bounds = Rect(700/~widthScaler0, 150/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~revChooserPop0[5].bounds = Rect(700/~widthScaler0, 187.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~revChooserPop0[6].bounds = Rect(700/~widthScaler0, 225/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~crossoverSlider0[0].view.bounds = Rect(300/~widthScaler0, 25/~heightScaler0, 233/~widthScaler0, 12.5/~heightScaler0);
	~mutationSlider0[0].view.bounds = Rect(500/~widthScaler0, 25/~heightScaler0, 233/~widthScaler0, 12.5/~heightScaler0);
	~algorithmButton0[0].bounds = Rect(300/~widthScaler0, 0, 100/~widthScaler0, 25/~heightScaler0);
	~crossoverSlider0[1].view.bounds = Rect(300/~widthScaler0, 62.5/~heightScaler0, 233/~widthScaler0, 12.5/~heightScaler0);
	~mutationSlider0[1].view.bounds = Rect(500/~widthScaler0, 62.5/~heightScaler0, 233/~widthScaler0, 12.5/~heightScaler0);
	~algorithmButton0[1].bounds = Rect(300/~widthScaler0, 37.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~crossoverSlider0[2].view.bounds = Rect(300/~widthScaler0, 100/~heightScaler0, 233/~widthScaler0, 12.5/~heightScaler0);
	~mutationSlider0[2].view.bounds = Rect(500/~widthScaler0, 100/~heightScaler0, 233/~widthScaler0, 12.5/~heightScaler0);
	~algorithmButton0[2].bounds = Rect(300/~widthScaler0, 75/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~crossoverSlider0[3].view.bounds = Rect(300/~widthScaler0, 137.5/~heightScaler0, 233/~widthScaler0, 12.5/~heightScaler0);
	~mutationSlider0[3].view.bounds = Rect(500/~widthScaler0, 137.5/~heightScaler0, 233/~widthScaler0, 12.5/~heightScaler0);
	~algorithmButton0[3].bounds = Rect(300/~widthScaler0, 112.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~crossoverSlider0[4].view.bounds = Rect(300/~widthScaler0, 175.5/~heightScaler0, 233/~widthScaler0, 12.5/~heightScaler0);
	~mutationSlider0[4].view.bounds = Rect(500/~widthScaler0, 175.5/~heightScaler0, 233/~widthScaler0, 12.5/~heightScaler0);
	~algorithmButton0[4].bounds = Rect(300/~widthScaler0, 150/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~crossoverSlider0[5].view.bounds = Rect(300/~widthScaler0, 213/~heightScaler0, 233/~widthScaler0, 12.5/~heightScaler0);
	~mutationSlider0[5].view.bounds = Rect(500/~widthScaler0, 213/~heightScaler0, 233/~widthScaler0, 12.5/~heightScaler0);
	~algorithmButton0[5].bounds = Rect(300/~widthScaler0, 188/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~algorithmButton0[6].bounds = Rect(300/~widthScaler0, 225.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~save0Button0[0].bounds = Rect(400/~widthScaler0, 0, 100/~widthScaler0, 25/~heightScaler0);
	~save0Button0[1].bounds = Rect(400/~widthScaler0, 37.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~save0Button0[2].bounds = Rect(400/~widthScaler0, 75/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~save0Button0[3].bounds = Rect(400/~widthScaler0, 112.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~save0Button0[4].bounds = Rect(400/~widthScaler0, 150/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~save0Button0[5].bounds = Rect(400/~widthScaler0, 187.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~save0Button0[6].bounds = Rect(400/~widthScaler0, 225/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~load0Button0[0].bounds = Rect(500/~widthScaler0, 0, 100/~widthScaler0, 25/~heightScaler0);
	~load0Button0[1].bounds = Rect(500/~widthScaler0, 37.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~load0Button0[2].bounds = Rect(500/~widthScaler0, 75/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~load0Button0[3].bounds = Rect(500/~widthScaler0, 112.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~load0Button0[4].bounds = Rect(500/~widthScaler0, 150/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~load0Button0[5].bounds = Rect(500/~widthScaler0, 187.5/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~load0Button0[6].bounds = Rect(500/~widthScaler0, 225/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~beatSwitch0.bounds = Rect(100/~widthScaler0, 125/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~masterSwitch0.bounds = Rect(100/~widthScaler0, 75/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~beatTrackChooser0.bounds = Rect(100/~widthScaler0, 100/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~onsetChooser0.bounds = Rect(200/~widthScaler0, 75/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~onsetChooser1.bounds = Rect(200/~widthScaler0, 100/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~onsetChooser2.bounds = Rect(200/~widthScaler0, 125/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~pitchTrackButton0.bounds = Rect(100/~widthScaler0, 150/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~envelopeAdjuster0.view.bounds = Rect(300/~widthScaler0, 275/~heightScaler0, 400/~widthScaler0, 25/~heightScaler0);
	~chooseTriggerButton0.bounds = Rect(300/~widthScaler0, 250/~heightScaler0, 200/~widthScaler0, 25/~heightScaler0);
	~chooseOnsetsButton0.bounds = Rect(500/~widthScaler0, 250/~heightScaler0, 200/~widthScaler0, 25/~heightScaler0);
	~pitchFixedButton0.bounds = Rect(200/~widthScaler0, 150/~heightScaler0, 50/~widthScaler0, 25/~heightScaler0);
	~pitchFixed0.bounds = Rect(250/~widthScaler0, 150/~heightScaler0, 50/~widthScaler0, 25/~heightScaler0);
	~scaleSelect0.bounds = Rect(15/~widthScaler0, 200/~heightScaler0, 75/~widthScaler0, 25/~heightScaler0);
	~noteText.bounds = Rect(15/~widthScaler0, 225/~heightScaler0, 75/~widthScaler0, 25/~heightScaler0);
	~scaleOnButton.bounds = Rect(15/~widthScaler0, 250/~heightScaler0, 75/~widthScaler0, 25/~heightScaler0);
	~noteView0.bounds = Rect(250/~widthScaler0, 200/~heightScaler0, 50/~widthScaler0, 50/~heightScaler0);
	~inView0.bounds = Rect(100/~widthScaler0, 200/~heightScaler0, 50/~widthScaler0, 50/~heightScaler0);
	~noteView1.bounds = Rect(150/~widthScaler0, 200/~heightScaler0, 50/~widthScaler0, 50/~heightScaler0);
	~outView0.bounds = Rect(200/~widthScaler0, 200/~heightScaler0, 50/~widthScaler0, 50/~heightScaler0);
	~autoFXButton0.bounds = Rect(100/~widthScaler0, 25/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~interactRestChooser0.bounds = Rect(250/~widthScaler0, 175/~heightScaler0, 25/~widthScaler0, 25/~heightScaler0);
	~interactTimeChooser0.bounds = Rect(275/~widthScaler0, 175/~heightScaler0, 25/~widthScaler0, 25/~heightScaler0);
	~interactPitchChooser0.bounds = Rect(200/~widthScaler0, 175/~heightScaler0, 50/~widthScaler0, 25/~heightScaler0);
	~interactButton0.bounds = Rect(100/~widthScaler0, 175/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~interactInputPop0.bounds = Rect(100/~widthScaler0, 200/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~visualiserButton0.bounds = Rect(200/~widthScaler0, 200/~heightScaler0, 75/~widthScaler0, 25/~heightScaler0);
	~visualDividerPopUp0.bounds = Rect(275/~widthScaler0, 200/~heightScaler0, 25/~widthScaler0, 25/~heightScaler0);
	~performanceButton0.bounds = Rect(25/~widthScaler0, 300/~heightScaler0, 100/~widthScaler0, 15/~heightScaler0);
	~performanceText0.bounds = Rect(128/~widthScaler0, 300/~heightScaler0, 100/~widthScaler0, 15/~heightScaler0);

	~fractal0Button0[0].bounds = Rect(((((1920/3)/4)*2) + (0 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal0Button0[1].bounds = Rect(((((1920/3)/4)*2) + (1 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal0Button0[2].bounds = Rect(((((1920/3)/4)*2) + (2 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal0Button0[3].bounds = Rect(((((1920/3)/4)*2) + (3 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal0Button0[4].bounds = Rect(((((1920/3)/4)*2) + (4 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal0Button0[5].bounds = Rect(((((1920/3)/4)*2) + (5 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal0Button0[6].bounds = Rect(((((1920/3)/4)*2) + (6 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal0Button0[7].bounds = Rect(((((1920/3)/4)*2) + (7 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal0Button0[8].bounds = Rect(((((1920/3)/4)*2) + (8 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal0Button0[9].bounds = Rect(((((1920/3)/4)*2) + (9 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal0Button0[10].bounds = Rect(((((1920/3)/4)*2) + (10 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal0Button0[11].bounds = Rect(((((1920/3)/4)*2) + (11 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal0Button0[12].bounds = Rect(((((1920/3)/4)*2) + (12 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);

	~fractal1Button0[0].bounds = Rect(((((1920/3)/4)*6) + (0 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal1Button0[1].bounds = Rect(((((1920/3)/4)*6) + (1 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal1Button0[2].bounds = Rect(((((1920/3)/4)*6) + (2 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal1Button0[3].bounds = Rect(((((1920/3)/4)*6) + (3 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal1Button0[4].bounds = Rect(((((1920/3)/4)*6) + (4 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal1Button0[5].bounds = Rect(((((1920/3)/4)*6) + (5 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal1Button0[6].bounds = Rect(((((1920/3)/4)*6) + (6 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal1Button0[7].bounds = Rect(((((1920/3)/4)*6) + (7 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal1Button0[8].bounds = Rect(((((1920/3)/4)*6) + (8 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal1Button0[9].bounds = Rect(((((1920/3)/4)*6) + (9 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal1Button0[10].bounds = Rect(((((1920/3)/4)*6) + (10 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal1Button0[11].bounds = Rect(((((1920/3)/4)*6) + (11 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal1Button0[12].bounds = Rect(((((1920/3)/4)*6) + (12 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);

	~fractal2Button0[0].bounds = Rect(((((1920/3)/4)*10) + (0 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal2Button0[1].bounds = Rect(((((1920/3)/4)*10) + (1 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal2Button0[2].bounds = Rect(((((1920/3)/4)*10) + (2 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal2Button0[3].bounds = Rect(((((1920/3)/4)*10) + (3 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal2Button0[4].bounds = Rect(((((1920/3)/4)*10) + (4 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal2Button0[5].bounds = Rect(((((1920/3)/4)*10) + (5 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal2Button0[6].bounds = Rect(((((1920/3)/4)*10) + (6 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal2Button0[7].bounds = Rect(((((1920/3)/4)*10) + (7 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal2Button0[8].bounds = Rect(((((1920/3)/4)*10) + (8 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal2Button0[9].bounds = Rect(((((1920/3)/4)*10) + (9 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal2Button0[10].bounds = Rect(((((1920/3)/4)*10) + (10 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal2Button0[11].bounds = Rect(((((1920/3)/4)*10) + (11 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~fractal2Button0[12].bounds = Rect(((((1920/3)/4)*10) + (12 * (1920/6)/13.2))/~widthScaler0, 246/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);

	~natural0Button0[0].bounds = Rect(((((1920/3)/4)*2) + (0 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural0Button0[1].bounds = Rect(((((1920/3)/4)*2) + (1 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural0Button0[2].bounds = Rect(((((1920/3)/4)*2) + (2 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural0Button0[3].bounds = Rect(((((1920/3)/4)*2) + (3 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural0Button0[4].bounds = Rect(((((1920/3)/4)*2) + (4 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural0Button0[5].bounds = Rect(((((1920/3)/4)*2) + (5 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural0Button0[6].bounds = Rect(((((1920/3)/4)*2) + (6 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural0Button0[7].bounds = Rect(((((1920/3)/4)*2) + (7 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural0Button0[8].bounds = Rect(((((1920/3)/4)*2) + (8 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural0Button0[9].bounds = Rect(((((1920/3)/4)*2) + (9 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural0Button0[10].bounds = Rect(((((1920/3)/4)*2) + (10 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural0Button0[11].bounds = Rect(((((1920/3)/4)*2) + (11 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural0Button0[12].bounds = Rect(((((1920/3)/4)*2) + (12 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);

	~natural1Button0[0].bounds = Rect(((((1920/3)/4)*6) + (0 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural1Button0[1].bounds = Rect(((((1920/3)/4)*6) + (1 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural1Button0[2].bounds = Rect(((((1920/3)/4)*6) + (2 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural1Button0[3].bounds = Rect(((((1920/3)/4)*6) + (3 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural1Button0[4].bounds = Rect(((((1920/3)/4)*6) + (4 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural1Button0[5].bounds = Rect(((((1920/3)/4)*6) + (5 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural1Button0[6].bounds = Rect(((((1920/3)/4)*6) + (6 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural1Button0[7].bounds = Rect(((((1920/3)/4)*6) + (7 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural1Button0[8].bounds = Rect(((((1920/3)/4)*6) + (8 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural1Button0[9].bounds = Rect(((((1920/3)/4)*6) + (9 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural1Button0[10].bounds = Rect(((((1920/3)/4)*6) + (10 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural1Button0[11].bounds = Rect(((((1920/3)/4)*6) + (11 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural1Button0[12].bounds = Rect(((((1920/3)/4)*6) + (12 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);

	~natural2Button0[0].bounds = Rect(((((1920/3)/4)*10) + (0 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural2Button0[1].bounds = Rect(((((1920/3)/4)*10) + (1 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural2Button0[2].bounds = Rect(((((1920/3)/4)*10) + (2 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural2Button0[3].bounds = Rect(((((1920/3)/4)*10) + (3 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural2Button0[4].bounds = Rect(((((1920/3)/4)*10) + (4 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural2Button0[5].bounds = Rect(((((1920/3)/4)*10) + (5 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural2Button0[6].bounds = Rect(((((1920/3)/4)*10) + (6 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural2Button0[7].bounds = Rect(((((1920/3)/4)*10) + (7 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural2Button0[8].bounds = Rect(((((1920/3)/4)*10) + (8 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural2Button0[9].bounds = Rect(((((1920/3)/4)*10) + (9 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural2Button0[10].bounds = Rect(((((1920/3)/4)*10) + (10 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural2Button0[11].bounds = Rect(((((1920/3)/4)*10) + (11 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);
	~natural2Button0[12].bounds = Rect(((((1920/3)/4)*10) + (12 * (1920/6)/13.2))/~widthScaler0, 350/~heightScaler0, ((1920/6)/13)/~widthScaler0, 14/~heightScaler0);

	~autoSpeedButton0.bounds = Rect(100/~widthScaler0, 50/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~resetSlicer0.bounds = Rect(100/~widthScaler0, 0, 100/~widthScaler0, 25/~heightScaler0);
	~stretchSlicer0.bounds = Rect(200/~widthScaler0, 0, 100/~widthScaler0, 25/~heightScaler0);
	~filterSlicer0.bounds = Rect(200/~widthScaler0, 25/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~grainSlicer0.bounds = Rect(200/~widthScaler0, 50/~heightScaler0, 100/~widthScaler0, 25/~heightScaler0);
	~receiverText.bounds = Rect(15/~widthScaler0, 135/~heightScaler0, 75/~widthScaler0, 15/~heightScaler0);
	~receiverButton.bounds = Rect(50/~widthScaler0, 135/~heightScaler0, 40/~widthScaler0, 15/~heightScaler0);
	~receiverButton1.bounds = Rect(50/~widthScaler0, 0, (40/8)/~widthScaler0, 15/~heightScaler0);
	~receiverButton2.bounds = Rect((50 + 5)/~widthScaler0, 0, (40/8)/~widthScaler0, 15/~heightScaler0);
	~receiverButton3.bounds = Rect((50 + 10)/~widthScaler0, 0, (40/8)/~widthScaler0, 15/~heightScaler0);
	~receiverButton4.bounds = Rect((50 + 15)/~widthScaler0, 0, (40/8)/~widthScaler0, 15/~heightScaler0);
	~receiverButton5.bounds = Rect((50 + 20)/~widthScaler0, 0, (40/8)/~widthScaler0, 15/~heightScaler0);
	~receiverButton6.bounds = Rect((50 + 25)/~widthScaler0, 0, (40/8)/~widthScaler0, 15/~heightScaler0);
	~receiverButton7.bounds = Rect((50 + 30)/~widthScaler0, 0, (40/8)/~widthScaler0, 15/~heightScaler0);
	~receiverButton8.bounds = Rect((50 + 35)/~widthScaler0, 0, (40/8)/~widthScaler0, 15/~heightScaler0);
	~networkSelectOn0.bounds = Rect(15/~widthScaler0, 167.5/~heightScaler0, 75/~widthScaler0, 25/~heightScaler0);
	~ipOfSender0.bounds = Rect(15/~widthScaler0, 15/~heightScaler0, 75/~widthScaler0, 15/~heightScaler0);
	~ipOfSender1.bounds = Rect(15/~widthScaler0, 30/~heightScaler0, 75/~widthScaler0, 15/~heightScaler0);
	~ipOfSender2.bounds = Rect(15/~widthScaler0, 45/~heightScaler0, 75/~widthScaler0, 15/~heightScaler0);
	~ipOfSender3.bounds = Rect(15/~widthScaler0, 60/~heightScaler0, 75/~widthScaler0, 15/~heightScaler0);
	~ipOfSender4.bounds = Rect(15/~widthScaler0, 75/~heightScaler0, 75/~widthScaler0, 15/~heightScaler0);
	~ipOfSender5.bounds = Rect(15/~widthScaler0, 90/~heightScaler0, 75/~widthScaler0, 15/~heightScaler0);
	~ipOfSender6.bounds = Rect(15/~widthScaler0, 105/~heightScaler0, 75/~widthScaler0, 15/~heightScaler0);
	~ipOfSender7.bounds = Rect(15/~widthScaler0, 120/~heightScaler0, 75/~widthScaler0, 15/~heightScaler0);
	~senderText.bounds = Rect(15/~widthScaler0, 0, 75/~widthScaler0, 15/~heightScaler0);
	~ipOfReceiver.bounds = Rect(15/~widthScaler0, 150/~heightScaler0, 75/~widthScaler0, 15/~heightScaler0);
	~randButton0.bounds = Rect((1920/3.25)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, 15/~heightScaler0);
	~differenceButton0.bounds = Rect((1920/3.25)/~widthScaler0, 15/~heightScaler0, ((1920/3)/20)/~widthScaler0, 15/~heightScaler0);
	~randButton1.bounds = Rect(((1920/3.25)+640)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, 15/~heightScaler0);
	~differenceButton1.bounds = Rect(((1920/3.25)+640)/~widthScaler0, 15/~heightScaler0, ((1920/3)/20)/~widthScaler0, 15/~heightScaler0);
	~randButton2.bounds = Rect(((1920/3.25)+1280)/~widthScaler0, 0, ((1920/3)/20)/~widthScaler0, 15/~heightScaler0);
	~randSampleButton0.bounds = Rect(((1920/3.25)+1280)/~widthScaler0, 15/~heightScaler0, ((1920/3)/20)/~widthScaler0, 15/~heightScaler0);

	};


}.defer;

1.wait;

{

// search for MIDI connectivity
MIDIIn.connectAll;
~connectTest = MIDIClient.sources.size;

// set CC responders to GUI objects
~ccResponders	= MIDIFunc.cc({arg value, num, chan;

				// Korg Knob 1 Scene 1
				if (num == 14 && chan == 0, {{~osc0StretchSlider0.valueAction = ~rate0Spec0.map(value/127);}.defer});
				// Korg Knob 2 Scene 1
				if (num == 15 && chan == 0, {{~osc0PitchSlider0.valueAction = ~pitch0spec0.map(value/127);}.defer});
				// Korg Knob 3 Scene 1
				if (num == 16 && chan == 0, {{~grainLengthSlider0.valueAction = ~grainLengthSpec0.map(value/127);}.defer});
				// Korg Knob 4 Scene 1
				if (num == 17 && chan == 0, {{~osc1StretchSlider0.valueAction = ~rate0Spec0.map(value/127);}.defer});
				// Korg Knob 5 Scene 1
				if (num == 18 && chan == 0, {{~osc1PitchSlider0.valueAction = ~pitch0spec0.map(value/127);}.defer});
				// Korg Knob 6 Scene 1
				if (num == 19 && chan == 0, {{~grainLengthSlider1.valueAction = ~grainLengthSpec0.map(value/127);}.defer});
				// Korg Knob 7 Scene 1
				if (num == 20 && chan == 0, {{~osc2StretchSlider0.valueAction = ~rate0Spec0.map(value/127);}.defer});
				// Korg Knob 8 Scene 1
				if (num == 21 && chan == 0, {{~osc2PitchSlider0.valueAction = ~pitch0spec0.map(value/127);}.defer});
				// Korg Knob 9 Scene 1
				if (num == 22 && chan == 0, {{~grainLengthSlider2.valueAction = ~grainLengthSpec0.map(value/127);}.defer});

				// Korg Knob 1 Scene 2
				if (num == 57 && chan == 0, {{~trackingUpdateSlider1.valueAction = ~meanSpec1.map(value/127);}.defer});
				// Korg Knob 2 Scene 2
				if (num == 58 && chan == 0, {{~filterAdjuster0.valueAction = ~adjusterSpec0.map(value/127);}.defer});
				// Korg Knob 3 Scene 2
				if (num == 59 && chan == 0, {{~samplerateSlider0.valueAction = ~sampleRateSpec0.map(value/127);}.defer});
				// Korg Knob 4 Scene 2
				if (num == 60 && chan == 0, {{~trackingUpdateSlider2.valueAction = ~meanSpec1.map(value/127);}.defer});
				// Korg Knob 5 Scene 2
				if (num == 61 && chan == 0, {{~filterAdjuster1.valueAction = ~adjusterSpec0.map(value/127);}.defer});
				// Korg Knob 6 Scene 2
				if (num == 62 && chan == 0, {{~samplerateSlider1.valueAction = ~sampleRateSpec0.map(value/127);}.defer});
				// Korg Knob 7 Scene 2
				if (num == 63 && chan == 0, {{~trackingUpdateSlider3.valueAction = ~meanSpec1.map(value/127);}.defer});
				// Korg Knob 8 Scene 2
				if (num == 65 && chan == 0, {{~filterAdjuster2.valueAction = ~adjusterSpec1.map(value/127);}.defer});
				// Korg Knob 9 Scene 2
				if (num == 66 && chan == 0, {{~samplerateSlider2.valueAction = ~sampleRateSpec0.map(value/127);}.defer});

				// Korg Fader 1 Scene 1
				if (num == 2 && chan == 0, {{~osc0LevelSlider0.valueAction = ~volumeSpec0.map(value/127);}.defer});
				// Korg Fader 2 Scene 1
				if (num == 3 && chan == 0, {{~grainLevel0Slider.valueAction = ~volumeSpec0.map(value/127);}.defer});
				// Korg Fader 3 Scene 1
				if (num == 4 && chan == 0, {{~filterSlider0.valueAction = ~volumeSpec0.map(value/127);}.defer});
				// Korg Fader 4 Scene 1
				if (num == 5 && chan == 0, {{~osc1LevelSlider0.valueAction = ~volumeSpec0.map(value/127);}.defer});
				// Korg Fader 5 Scene 1
				if (num == 6 && chan == 0, {{~grainLevel1Slider.valueAction = ~volumeSpec0.map(value/127);}.defer});
				// Korg Fader 6 Scene 1
				if (num == 8 && chan == 0, {{~filterSlider1.valueAction = ~volumeSpec0.map(value/127);}.defer});
				// Korg Fader 7 Scene 1
				if (num == 9 && chan == 0, {{~osc2LevelSlider0.valueAction = ~volumeSpec0.map(value/127);}.defer});
				// Korg Fader 8 Scene 1
				if (num == 12 && chan == 0, {{~grainLevel2Slider.valueAction = ~volumeSpec0.map(value/127);}.defer});
				// Korg Fader 9 Scene 1
				if (num == 13 && chan == 0, {{~filterSlider2.valueAction = ~volumeSpec0.map(value/127);}.defer});


				// Korg Fader 1 Scene 2
				if (num == 42 && chan == 0, {{~mainOutSlider0.valueAction = ~volumeSpec0.map(value/127);}.defer});
				// Korg Fader 2 Scene 2
				if (num == 43 && chan == 0, {{~micLevelSlider0.valueAction = ~micLevelSpec0.map(value/127);}.defer});
				// Korg Fader 3 Scene 2
				if (num == 50 && chan == 0, {{~dryLevelSlider0.valueAction = ~volumeSpec0.map(value/127);}.defer});
				// Korg Fader 3 Scene 2
				if (num == 51 && chan == 0, {{~fxLevelSlider0.valueAction = ~volumeSpec0.map(value/127);}.defer});



				// Korg Top Button 1 Scene 1
				if (num == 23 && chan == 0, {{~filterOn0.valueAction = (value/127);}.defer});
				// Korg Bottom Button 1 Scene 1
				if (num == 33 && chan == 0, {{~onsetChooser0.valueAction = (value/127);}.defer});
				// Korg Top Button 4 Scene 1
				if (num == 26 && chan == 0, {{~filterOn1.valueAction = (value/127);}.defer});
				// Korg Bottom Button 4 Scene 1
				if (num == 36 && chan == 0, {{~onsetChooser1.valueAction = (value/127);}.defer});
				// Korg Top Button 7 Scene 1
				if (num == 29 && chan == 0, {{~filterOn2.valueAction = (value/127);}.defer});
				// Korg Bottom Button 7 Scene 1
				if (num == 39 && chan == 0, {{~onsetChooser2.valueAction = (value/127);}.defer});


				// Korg Top Button 2 Scene 1
				if (num == 24 && chan == 0 && value == 0, {{~pitchFixedButton0.valueAction = (value/127);}.defer});
				// Korg Top Button 2 Scene 1
				if (num == 24 && chan == 0 && value == 127, {{~pitchFixedButton0.valueAction = (value/127);}.defer});
				// Korg Bottom Button 2 Scene 1
				if (num == 34 && chan == 0 && value == 0, {{~pitchTrackButton0.valueAction = (value/127);}.defer});
				// Korg Bottom Button 2 Scene 1
				if (num == 34 && chan == 0 && value == 127, {{~pitchTrackButton0.valueAction = (value/127);}.defer});

				// Korg Bottom Button 7 Scene 1
				if (num == 31 && chan == 0, {{~recordSwitch0.valueAction = (value/127);}.defer});
				if (num == 75 && chan == 0, {{~recordSwitch0.valueAction = (value/127);}.defer});
				if (num == 115 && chan == 0, {{~recordSwitch0.valueAction = (value/127);}.defer});

				//Korg 'rewind' button
				if (num == 47 && chan == 0 && value == 127, {{~triggerButton0.valueAction = (value/127);}.defer});
				if (num == 47 && chan == 0 && value == 0, {{~triggerButton0.valueAction = (value/127);}.defer});

				//Korg 'play' button
				if (num == 45 && chan == 0 && value == 127, {{~triggerButton1.valueAction = (value/127);}.defer});
				if (num == 45 && chan == 0 && value == 0, {{~triggerButton1.valueAction = (value/127);}.defer});

				//Korg 'forward' button
				if (num == 48 && chan == 0 && value == 127, {{~triggerButton2.valueAction = (value/127);}.defer});
				if (num == 48 && chan == 0 && value == 0, {{~triggerButton2.valueAction = (value/127);}.defer});

				//Korg 'loop' button
				if (num == 49 && chan == 0 && value == 127, {{~triggerButton0.valueAction = (value/127);}.defer});
				if (num == 49 && chan == 0 && value == 0, {{~triggerButton0.valueAction = (value/127);}.defer});

				//Korg 'stop' button
				if (num == 46 && chan == 0 && value == 127, {{~triggerButton1.valueAction = (value/127);}.defer});
				if (num == 46 && chan == 0 && value == 0, {{~triggerButton1.valueAction = (value/127);}.defer});

				//Korg 'record' button
				if (num == 44 && chan == 0 && value == 127, {{~triggerButton2.valueAction = (value/127);}.defer});
				if (num == 44 && chan == 0 && value == 0, {{~triggerButton2.valueAction = (value/127);}.defer});
				});

}.defer;

0.06.wait;


// end initiation task
~finishedTask = 0;

~loadedGraphicTask = Task({
		inf.do({arg i;

		~loadPosition0 = i * 2;

		0.05.wait;

		});
		}).stop;

~midiTask = Task({
		loop({arg i;

if(~connectTest >= 0,

	{

		~loadedGraphicTask.start;

		~loadedTask = Task({

		1.do({arg i;
		{
		~loadTask.stop;



		~loadText.string = "     Loaded...";


		~loadWindow.refresh;

		}.defer;

		7.wait;

	{
	~loadedGraphicTask.stop;
	~loadedTask.stop;
	~loadWindow.close;
	~midiTask.stop;
	}.defer;

 	~finishedTask = 1;

	});
	}).play;


		},

{};


);

0.05.wait;

});
}).play;

~doneTask = Task({
		loop({arg i;


if((~finishedTask == 1) && (~connectTest == 0),

	{

	~welcomeTask = Task({

	1.do({arg i;
		{

// if not MIDI found, post in post Window
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ " Welcome To Genesis. No MIDI is Connected " ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~doneTask.stop;
	~textEditor.editable = false;
		}.defer;

	});
	}).play;
	});

if((~finishedTask == 1) && (~connectTest >= 1),

	{

	~welcomeTask = Task({

	1.do({arg i;
		{

// if MIDI found, post in post Window
	~textEditor.stringColor_(Color.black, (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.string_(" \n\n " ++ " Welcome To Genesis. MIDI Found " ++ " ", (~textEditor.string.size), (~textEditor.string.size));
	~textEditor.selectLine(~textEditor.string.size);
	~doneTask.stop;
	~textEditor.editable = false;
		}.defer;

	});
	}).play;
	});


0.05.wait;
});
}).play;


});
}).play;
