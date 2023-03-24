<template>
  <header
    style="background: linear-gradient(135deg, rgb(42, 39, 218) 0%, rgb(0, 204, 255) 100%);position: relative"
    class="flex justify-between p-5 w-full chat-header"
    :class="$dm('bg-white', 'dark:bg-slate-900')"
  >
    <div style="width: 50%;display: flex;justify-content: start;">
        <available-agents v-if="isOnline" :agents="availableAgents" />
    </div>
    <div class="flex items-center">
      <button v-if="showBackButton" @click="onBackButtonClick">
        <fluent-icon
          icon="chevron-left"
          size="24"
          :class="$dm('text-black-900', 'dark:text-slate-50')"
        />
      </button>
      <div>
        <div class="font-medium text-base flex items-center text-white text-2xl">
            <span class="mr-1"  style="position: relative;top: 5px">
                Hi There!
            </span>
          <img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAEgAAABICAMAAABiM0N1AAAAwFBMVEVHcExdrez/3F3/3F1drexdrez/3F3/3F3/3F3/3F3/3F1drexdrexdrexdrez/3F1drez/3F3/3F1drez/3F3/3F1drez/3F1drexdrexdrez/3F1drez/3F3wm0ZdrezvlkXvlkXvlkXvlkX2tU/+11tvstz90lr5wlTvlkXvlkXvlkX4u1L4vVLvlkVdrez/3F3wmkf+2Fz7y1fyo0rxn0j2tVD5wlT3uVH6xlb0rE3zqEv4vVP8z1n901r1sE7Bu7vOAAAALnRSTlMAQK9ggBBAEO+Az5/PYDAgv99Q779wjzBQ33Cfr4+AIDC/cCDXz4/fgJ9Az++Pgf5MAQAAA8ZJREFUeNqlmFt32joQhcdgY2ODMT7mGkh6TntuvchDzCUhSfv//1UXyPJIHsldod9LeGDtaM8ejSTgVvyyLEfJOIDfJCglf8yD3xZSUkvoJo8R70JwMS8b5tBFHy/EIa9Mucr8FCD1lv7o10oTlPQchlb+tTaelFp2LkiSMyFVGx8uJNfPvOLhMMJpH+AT1kQTZk0xShsln+nEeGH7cY+KAgw8b5ys1KLGAAAj25KGKPkmnlExA8YyKyUXJU9+MPlXGdrtHjVzHG+llOSSEjD4q8KaZ3HWzXGCRLpL690CBn++ouKsmRuyTi0WAGtZcYDl5W9L6NAYetTM4QKIfuN3fFVag8eF/hdHVFTiBRUxEFHdqdRDKRf6LESFiqN4tZgbYE1Yl7lcX/adb7Zi9FXsyNxh9x0VAybUV8mvrK14EmeruWmovof6Lrz2U9pqRZ7Wk3hCxRZqpro3T3rT+duW1l68MXM93Rtc+nIDGh+oFTVDb2LPzA0Nb/N2ke6fWmlxcz2qNnkbt6O/Z2lxczlV28zN2GWOtL7vqNmj0Kx2zyb0UYhnq7lXcWyZ6+neAtbV98KR1ouozNE0NLz5bDx+EWeWFjM3MapdgI0PgqVlH00hNvCRN7krik/Ckda5NXenplV++Jz0VtzZR1O00Ksdt9fjTIubi1W1aeIRM/Wv9zt7WscTKh7vISehOzAYutNSkGXxX4Ro9CiRW9M6iR9Mp9qRYxoBxNSVFl/PCQ2mYDDQvrpnaek6tGD7kraOtEwfe4vZgk1sW1qmjydhK/8ADBbutMipqJDT4/cQbq61oBfk8A0Xm2lxaEGs3NwcpcU4UbN2e4OZsbcYP+RG5ETQpiBzFhcH1aqMkA2lqDH3wrw9CoEOBsDNcfjR4haia0nvFiG689BFKYxuFzIPufwWoZkhlAKZu7VGAb1L3ObexOHXxdafSgN0wOPnfTTSLzlb5NB46e7sRPMG4RQdm//YvdfUbSmjufu+IvXb77kxH02tQfvsLJG6lmzMZ2CMDDrRuTNKTHYSvXAWriVV1vBJyAP5kEu6zVW20VaAIZSWpNRh7lDxBelC6+bVOwpoNDG6s8/qq3tG7102mjj8EiHfgQFAMColmezMO2R0D8cHVZsgK2tW82VKZy/DdRJtmmb0S51/4vfpQEqlSTNdKYzfoUMLSR6uM25DQhB21inKoU1SXtmsPQ8gGCej5rec3N0FxQTApUS/lgSeJ0eva1HTHDhmmflVPuIyfXBBZQZG2O/pWvF2AV08rDOyxljkwyuzQQh2fgLrB1woYWK5YwAAAABJRU5ErkJggg==" alt="avatar" class="h-8 w-8 rounded-full mr-3">

        </div>
      </div>
    </div>
    <header-actions :show-popout-button="showPopoutButton" />
  </header>
</template>

<script>
import { mapGetters } from 'vuex';

import availabilityMixin from 'widget/mixins/availability';
import FluentIcon from 'shared/components/FluentIcon/Index.vue';
import HeaderActions from './HeaderActions';
import routerMixin from 'widget/mixins/routerMixin';
import darkMixin from 'widget/mixins/darkModeMixin.js';
import AvailableAgents from 'widget/components/AvailableAgents.vue';

export default {
  name: 'ChatHeader',
  components: {
    AvailableAgents,
    FluentIcon,
    HeaderActions,
  },
  mixins: [availabilityMixin, routerMixin, darkMixin],
  props: {
    avatarUrl: {
      type: String,
      default: '',
    },
    title: {
      type: String,
      default: '',
    },
    showPopoutButton: {
      type: Boolean,
      default: false,
    },
    showBackButton: {
      type: Boolean,
      default: false,
    },
    availableAgents: {
      type: Array,
      default: () => {},
    },
  },
  computed: {
    ...mapGetters({
      widgetColor: 'appConfig/getWidgetColor',
    }),
    isOnline() {
      const { workingHoursEnabled } = this.channelConfig;
      const anyAgentOnline = this.availableAgents.length > 0;

      if (workingHoursEnabled) {
        return this.isInBetweenTheWorkingHours;
      }
      return anyAgentOnline;
    },
    replyWaitMessage() {
      return this.isOnline
        ? this.replyTimeStatus
        : this.$t('TEAM_AVAILABILITY.OFFLINE');
    },
  },
  methods: {
    onBackButtonClick() {
      this.replaceRoute('home');
    },
  },
};
</script>
<style>
.is-widget-right .chat-header:after {
    content: "";
    position: absolute;
    width: calc(100% + 5px);
    bottom: -8px;;
    left: -5px;
    border-image-source: url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAzNzIgMTUiPgogIDxwYXRoIGQ9Ik0zNDkuOCAxLjRDMzM0LjUuNCAzMTguNSAwIDMwMiAwaC0yLjVjLTkuMSAwLTE4LjQuMS0yNy44LjQtMzQuNSAxLTY4LjMgMy0xMDIuMyA0LjctMTQgLjUtMjggMS4yLTQxLjUgMS42Qzg0IDcuNyA0MS42IDUuMyAwIDIuMnY4LjRjNDEuNiAzIDg0IDUuMyAxMjguMiA0LjEgMTMuNS0uNCAyNy41LTEuMSA0MS41LTEuNiAzMy45LTEuNyA2Ny44LTMuNiAxMDIuMy00LjcgOS40LS4zIDE4LjctLjQgMjcuOC0uNGgyLjVjMTYuNSAwIDMyLjQuNCA0Ny44IDEuNCA4LjQuMyAxNS42LjcgMjIgMS4yVjIuMmMtNi41LS41LTEzLjgtLjUtMjIuMy0uOHoiIGZpbGw9IiNmZmYiLz4KPC9zdmc+Cg==) !important;
    border-image-slice: 0 0 100%;
    border-image-width: 0 0 15px;
    border-image-repeat: stretch;
    border-width: 0px 0px 15px;
}
</style>
