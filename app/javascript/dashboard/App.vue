<script>
import { mapGetters } from 'vuex';
import LoadingState from './components/widgets/LoadingState.vue';
import NetworkNotification from './components/NetworkNotification.vue';
import UpdateBanner from './components/app/UpdateBanner.vue';
import PaymentPendingBanner from './components/app/PaymentPendingBanner.vue';
import PendingEmailVerificationBanner from './components/app/PendingEmailVerificationBanner.vue';
import vueActionCable from './helper/actionCable';
import { useRouter } from 'vue-router';
import { useStore } from 'dashboard/composables/store';
import WootSnackbarBox from './components/SnackbarContainer.vue';
import { setColorTheme } from './helper/themeHelper';
import { isOnOnboardingView } from 'v3/helpers/RouteHelper';
import { useAccount } from 'dashboard/composables/useAccount';
import { useFontSize } from 'dashboard/composables/useFontSize';
import {
  registerSubscription,
  verifyServiceWorkerExistence,
} from './helper/pushHelper';
import ReconnectService from 'dashboard/helper/ReconnectService';
import { useUISettings } from 'dashboard/composables/useUISettings';

export default {
  name: 'App',

  components: {
    LoadingState,
    NetworkNotification,
    UpdateBanner,
    PaymentPendingBanner,
    WootSnackbarBox,
    PendingEmailVerificationBanner,
  },
  setup() {
    const router = useRouter();
    const store = useStore();
    const { accountId } = useAccount();
    // Use the font size composable (it automatically sets up the watcher)
    const { currentFontSize } = useFontSize();
    const { uiSettings } = useUISettings();

    return {
      router,
      store,
      currentAccountId: accountId,
      currentFontSize,
      uiSettings,
    };
  },
  data() {
    return {
      latestChatwootVersion: null,
      reconnectService: null,
    };
  },
  computed: {
    ...mapGetters({
      getAccount: 'accounts/getAccount',
      isRTL: 'accounts/isRTL',
      currentUser: 'getCurrentUser',
      authUIFlags: 'getAuthUIFlags',
      accountUIFlags: 'accounts/getUIFlags',
    }),
    hideOnOnboardingView() {
      return !isOnOnboardingView(this.$route);
    },
  },

  watch: {
    currentAccountId: {
      immediate: true,
      handler() {
        if (this.currentAccountId) {
          this.initializeAccount();
        }
      },
    },
  },
  mounted() {
    this.initializeColorTheme();
    this.listenToThemeChanges();
    // If user locale is set, use it; otherwise use account locale
    this.setLocale(
      this.uiSettings?.locale || window.chatwootConfig.selectedLocale
    );
  },
  unmounted() {
    if (this.reconnectService) {
      this.reconnectService.disconnect();
    }
  },
  methods: {
    initializeColorTheme() {
      setColorTheme(window.matchMedia('(prefers-color-scheme: dark)').matches);
    },
    listenToThemeChanges() {
      const mql = window.matchMedia('(prefers-color-scheme: dark)');
      mql.onchange = e => setColorTheme(e.matches);
    },
    setLocale(locale) {
      this.$root.$i18n.locale = locale;
    },
    async initializeAccount() {
      await this.$store.dispatch('accounts/get');
      this.$store.dispatch('setActiveAccount', {
        accountId: this.currentAccountId,
      });
      const { locale, latest_chatwoot_version: latestChatwootVersion } =
        this.getAccount(this.currentAccountId);
      const { pubsub_token: pubsubToken } = this.currentUser || {};
      // If user locale is set, use it; otherwise use account locale
      this.setLocale(this.uiSettings?.locale || locale);
      this.latestChatwootVersion = latestChatwootVersion;
      vueActionCable.init(this.store, pubsubToken);
      this.reconnectService = new ReconnectService(this.store, this.router);
      window.reconnectService = this.reconnectService;

      verifyServiceWorkerExistence(registration =>
        registration.pushManager.getSubscription().then(subscription => {
          if (subscription) {
            registerSubscription();
          }
        })
      );
    },
  },
};
</script>

<template>
  <div
    v-if="!authUIFlags.isFetching && !accountUIFlags.isFetchingItem"
    id="app"
    class="flex flex-col w-full h-screen min-h-0 bg-n-background"
    :class="{ 'agent': currentUser.role != 'administrator', 'admin': currentUser.role == 'administrator' }"
    :dir="isRTL ? 'rtl' : 'ltr'"
  >
    <UpdateBanner :latest-chatwoot-version="latestChatwootVersion" />
    <template v-if="currentAccountId">
      <PendingEmailVerificationBanner v-if="hideOnOnboardingView" />
      <PaymentPendingBanner v-if="hideOnOnboardingView" />
    </template>
    <router-view v-slot="{ Component }">
      <transition name="fade" mode="out-in">
        <component :is="Component" />
      </transition>
    </router-view>
    <WootSnackbarBox />
    <NetworkNotification />
  </div>
  <LoadingState v-else />
</template>

<style lang="scss">
@import './assets/scss/app';

.v-popper--theme-tooltip .v-popper__inner {
  background: black !important;
  font-size: 0.75rem;
  padding: 4px 8px !important;
  border-radius: 6px;
  font-weight: 400;
}

.v-popper--theme-tooltip .v-popper__arrow-container {
  display: none;
}
</style>

<style>
.agent li.flex-shrink-0.my-0.mx-2.ltr\:first\:ml-0.rtl\:first\:mr-0.ltr\:last\:mr-0.rtl\:last\:ml-0.hover\:text-n-slate-12.text-sm.\[\&_a\]\:font-medium:nth-child(3), .agent li.flex-shrink-0.my-0.mx-2.ltr\:first\:ml-0.rtl\:first\:mr-0.ltr\:last\:mr-0.rtl\:last\:ml-0.hover\:text-n-slate-12.text-sm.\[\&_a\]\:font-medium:nth-child(2) {
    display:none;
}


.agent .context-menu-container .menu:nth-child(1),
.agent .context-menu-container .menu:nth-child(2),
.agent .context-menu-container .menu:nth-child(3) {
    display:none;
}


.agent .context-menu-container .menu-container .menu-with-submenu:nth-child(1),
.agent .context-menu-container .menu-container .menu-with-submenu:nth-child(2),
.agent .context-menu-container .menu-container .menu-with-submenu:nth-child(3),
.agent .context-menu-container .menu-container .menu-with-submenu:nth-child(4),
.agent .context-menu-container .menu-container .menu-with-submenu:nth-child(6),
.agent .context-menu-container .menu-container .menu-with-submenu:nth-child(7),
.agent .context-menu-container .menu-container .menu-with-submenu:nth-child(8)
{
    display:none;
}

.agent .conversation-header--details .header-actions-wrap .flex-container.actions--container {
    display:none !important;
}

.agent .conversation--actions {
    display:none !important;
}

.emoji-reaction {
    position: absolute;
    top: -4px;
    left: -26px;
    background: #ffffff;
    border: 1px solid #ebf0f5;
    border-radius: 101px;
    padding: 0px;
    z-index: 1;
}

.incoming .emoji-reaction {
    right:-16px;
    left:auto !important;
}
.bubble.is-deleted {
    background:#ff511e !important;;
}

.is-deleted .delete-icon {
    display:block !important;
}

span.delete-icon {
    display: block;
    min-height: 20px;
}
.message-text--metadata {
    padding-top: 4px !important;
}

.bubble.is-image {
    overflow: initial !important;
}
</style>
