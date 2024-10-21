<script>
import { mapGetters } from 'vuex';
import AddAccountModal from '../dashboard/components/layout/sidebarComponents/AddAccountModal.vue';
import LoadingState from './components/widgets/LoadingState.vue';
import NetworkNotification from './components/NetworkNotification.vue';
import UpdateBanner from './components/app/UpdateBanner.vue';
import UpgradeBanner from './components/app/UpgradeBanner.vue';
import PaymentPendingBanner from './components/app/PaymentPendingBanner.vue';
import PendingEmailVerificationBanner from './components/app/PendingEmailVerificationBanner.vue';
import vueActionCable from './helper/actionCable';
import { useRouter } from 'vue-router';
import { useStore } from 'dashboard/composables/store';
import WootSnackbarBox from './components/SnackbarContainer.vue';
import { setColorTheme } from './helper/themeHelper';
import { isOnOnboardingView } from 'v3/helpers/RouteHelper';
import { useAccount } from 'dashboard/composables/useAccount';
import {
  registerSubscription,
  verifyServiceWorkerExistence,
} from './helper/pushHelper';
import ReconnectService from 'dashboard/helper/ReconnectService';

export default {
  name: 'App',

  components: {
    AddAccountModal,
    LoadingState,
    NetworkNotification,
    UpdateBanner,
    PaymentPendingBanner,
    WootSnackbarBox,
    UpgradeBanner,
    PendingEmailVerificationBanner,
  },
  setup() {
    const router = useRouter();
    const store = useStore();
    const { accountId } = useAccount();

    return { router, store, currentAccountId: accountId };
  },
  data() {
    return {
      showAddAccountModal: false,
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
    hasAccounts() {
      const { accounts = [] } = this.currentUser || {};
      return accounts.length > 0;
    },
    hideOnOnboardingView() {
      return !isOnOnboardingView(this.$route);
    },
  },

  watch: {
    currentUser() {
      if (!this.hasAccounts) {
        this.showAddAccountModal = true;
      }
    },
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
    this.setLocale(window.chatwootConfig.selectedLocale);
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
      this.setLocale(locale);
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
    class="flex-grow-0 w-full h-full min-h-0 app-wrapper"
    :class="{ 'app-rtl--wrapper': isRTL }"
    :dir="isRTL ? 'rtl' : 'ltr'"
  >
    <UpdateBanner :latest-chatwoot-version="latestChatwootVersion" />
    <template v-if="currentAccountId">
      <PendingEmailVerificationBanner v-if="hideOnOnboardingView" />
      <PaymentPendingBanner v-if="hideOnOnboardingView" />
      <UpgradeBanner />
    </template>
    <router-view v-slot="{ Component }">
      <transition name="fade" mode="out-in">
        <component :is="Component" />
      </transition>
    </router-view>
    <AddAccountModal :show="showAddAccountModal" :has-accounts="hasAccounts" />
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

.multiselect__input {
  margin-bottom: 0px !important;
}
</style>

<style src="vue-multiselect/dist/vue-multiselect.css"></style>

<style>
.agent .tab--chat-type.tabs--container--with-border.tabs--container .tabs-title:not(.is-active) {
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
    left: -16px;
    background: #ffffff;
    border: 1px solid #ebf0f5;
    border-radius: 101px;
    padding: 3px;
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
