<template>
	<body>
		<audio id="audio_on" src="mic_click_on.ogg"></audio>
		<audio id="audio_off" src="mic_click_off.ogg"></audio>
		<div v-if="voice.uiEnabled" class="voiceInfo">
			<p v-if="voice.callInfo !== 0" :class="{ talking: voice.talking }">
				<button class="mdui-btn mdui-btn-icon mdui-color-theme-accent mdui-btn-raised" :class="{ talking: voice.talking }" :style="voice.voiceStatusStyle">
					<i v-if="voice.callInfo !== 0" class="mdui-icon material-icons mdui-text-color-white-icon">phone_in_talk</i>
					<i v-else-if="voice.radioEnabled && voice.radioChannel !== 0" class="mdui-icon material-icons mdui-text-color-white-icon">wifi_tethering</i>
					<i v-else-if="voice.voiceModes.length" class="mdui-icon material-icons mdui-text-color-white-icon">mic</i>
					<i v-else class="mdui-icon material-icons mdui-text-color-white-icon">mic_off</i>
				</button>
			</p>
		</div>
	</body>
</template>

<script>
import { reactive } from "vue";
export default {
	name: "App",
	setup() {
		const voice = reactive({
			uiEnabled: true,
			voiceModes: [],
			voiceMode: 0,
			radioChannel: 0,
			radioEnabled: true,
			usingRadio: false,
			callInfo: 0,
			talking: false,
		});

		// stops from toggling voice at the end of talking
		window.addEventListener("message", function(event) {
			const data = event.data;

			if (data.uiEnabled !== undefined) {
				voice.uiEnabled = data.uiEnabled
			}

			if (data.voiceModes !== undefined) {
				voice.voiceModes = JSON.parse(data.voiceModes);
				// Push our own custom type for modes that have their range changed
				let voiceModes = [...voice.voiceModes]
				voiceModes.push([0.0, "Custom"])
				voice.voiceModes = voiceModes
			}

			if (data.voiceMode !== undefined) {
				voice.voiceMode = data.voiceMode;
				if (data.voiceMode == 0) {
					voice.voiceStatusStyle = { background: "linear-gradient(180deg, #e6a400 0%, #916800 100%)", transition: "all 0.1s linear" }
				} else if (data.voiceMode == 1) {
					voice.voiceStatusStyle = { background: "linear-gradient(180deg, #18b70b 0%, #0d9900 100%)", transition: "all 0.1s linear" }
				} else if (data.voiceMode == 2) {
					voice.voiceStatusStyle = { background: "linear-gradient(180deg, #ff0000 0%, #920000 100%)", transition: "all 0.1s linear" }
				} else {
					voice.voiceStatusStyle = { background: "linear-gradient(180deg, #7e7e7e 0%, #424242 100%)", transition: "all 0.1s linear" }
				}
			}

			if (data.radioChannel !== undefined) {
				voice.radioChannel = data.radioChannel;
			}

			if (data.radioEnabled !== undefined) {
				voice.radioEnabled = data.radioEnabled;
			}

			if (data.callInfo !== undefined) {
				voice.callInfo = data.callInfo;
			}

			if (data.usingRadio !== undefined && data.usingRadio !== voice.usingRadio) {
				voice.usingRadio = data.usingRadio;
			}
			
			if ((data.talking !== undefined) && !voice.usingRadio) {
				voice.talking = data.talking;
			}

			// if (data.sound && voice.radioEnabled && voice.radioChannel !== 0) {
			// 	let click = document.getElementById(data.sound);
			// 	// discard these errors as its usually just a 'uncaught promise' from two clicks happening too fast.
			// 	click.load();
			// 	click.volume = data.volume;
			// 	click.play().catch((e) => {});
			// }
		});

		fetch(`https://${GetParentResourceName()}/uiReady`, { method: 'POST' });

		return { voice };
	}
};
</script>

<style>
.voiceInfo {
    font-family: Avenir, Helvetica, Arial, sans-serif;
    position: fixed;
    text-align: right;
    padding: 0;
    bottom: 8px;
    left: 122px;
    font-size: 12px;
    font-weight: 700;
    color: #949697;
    text-shadow: 1.25px 0 0 #000, 0 -1.25px 0 #000, 0 1.25px 0 #000, -1.25px 0 0 #000
}

@-webkit-keyframes trew-soundwave {
    0% {
        box-shadow: 0 0 0 0 hsla(0, 0%, 100%, .75)
    }

    to {
        box-shadow: 0 0 0 25px hsla(0, 0%, 100%, 0)
    }
}

@keyframes trew-soundwave {
    0% {
        box-shadow: 0 0 0 0 hsla(0, 0%, 100%, .75)
    }

    to {
        box-shadow: 0 0 0 25px hsla(0, 0%, 100%, 0)
    }
}

.talking {
    -webkit-animation: trew-soundwave 1s infinite;
    animation: trew-soundwave 1s infinite;
    border: 3px solid #00c711;
    transition: all .1s linear
}

.mdui-btn-icon {
    border-radius: 10px;
    width: 34px;
    height: 29px
}

.material-icons {
    font-size: 18px
}

p {
    margin: 0
}

body {
    background-color: transparent !important
}
</style>
