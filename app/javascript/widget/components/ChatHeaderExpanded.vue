<template>
  <header
    style="background: linear-gradient(135deg, rgb(42, 39, 218) 0%, rgb(0, 204, 255) 100%);"
    class="header-expanded py-6 px-5 relative box-border w-full chat-header-x"
    :class="$dm('bg-white', 'dark:bg-slate-900')"
  >
    <div
      class="flex items-start"
      :class="[avatarUrl ? 'justify-between' : 'justify-end']"
    >
      <img
        style="background: #fff"
        v-if="avatarUrl"
        class="h-12 rounded-full"
        :src="avatarUrl"
        alt="Avatar"
      />
      <header-actions :show-popout-button="showPopoutButton" />
    </div>
    <h2
      v-dompurify-html="introHeading"
      class="mt-5 text-3xl mb-3 font-normal"
      :class="$dm('text-white', 'dark:text-slate-50')"
    />
    <p
      v-dompurify-html="introBody"
      class="text-lg leading-normal"
      :class="$dm('text-white', 'dark:text-slate-200')"
    />
  </header>
</template>

<script>
import { mapGetters } from 'vuex';
import HeaderActions from './HeaderActions';
import darkModeMixin from 'widget/mixins/darkModeMixin.js';

export default {
  name: 'ChatHeaderExpanded',
  components: {
    HeaderActions,
  },
  mixins: [darkModeMixin],
  props: {
    avatarUrl: {
      type: String,
      default: '',
    },
    introHeading: {
      type: String,
      default: '',
    },
    introBody: {
      type: String,
      default: '',
    },
    showPopoutButton: {
      type: Boolean,
      default: false,
    },
  },
  computed: {
    ...mapGetters({
      widgetColor: 'appConfig/getWidgetColor',
    }),
  },
};
</script>
<style>
.is-widget-right .chat-header-x:after {
    content: "";
    position: absolute;
    width: calc(100% + 5px);
    bottom: -8px;
    left: -5px;
    border-image-source: url(data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAzNzIgMTUiPgogIDxwYXRoIGQ9Ik0zNDkuOCAxLjRDMzM0LjUuNCAzMTguNSAwIDMwMiAwaC0yLjVjLTkuMSAwLTE4LjQuMS0yNy44LjQtMzQuNSAxLTY4LjMgMy0xMDIuMyA0LjctMTQgLjUtMjggMS4yLTQxLjUgMS42Qzg0IDcuNyA0MS42IDUuMyAwIDIuMnY4LjRjNDEuNiAzIDg0IDUuMyAxMjguMiA0LjEgMTMuNS0uNCAyNy41LTEuMSA0MS41LTEuNiAzMy45LTEuNyA2Ny44LTMuNiAxMDIuMy00LjcgOS40LS4zIDE4LjctLjQgMjcuOC0uNGgyLjVjMTYuNSAwIDMyLjQuNCA0Ny44IDEuNCA4LjQuMyAxNS42LjcgMjIgMS4yVjIuMmMtNi41LS41LTEzLjgtLjUtMjIuMy0uOHoiIGZpbGw9IiNmZmYiLz4KPC9zdmc+Cg==);
    border-image-slice: 0 0 100%;
    border-image-width: 0 0 15px;
    border-image-repeat: stretch;
    border-width: 0px 0px 15px;
}
</style>
