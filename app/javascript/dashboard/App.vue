<template>
  <div
    v-if="!authUIFlags.isFetching"
    id="app"
    class="app-wrapper app-root"
    :class="{ 'app-rtl--wrapper': isRTLView, 'agent': currentUser.role != 'administrator', 'admin': currentUser.role == 'administrator' }"
  >
    <update-banner :latest-chatwoot-version="latestChatwootVersion" />
    <transition name="fade" mode="out-in">
      <router-view />
    </transition>
    <add-account-modal
      :show="showAddAccountModal"
      :has-accounts="hasAccounts"
    />
    <woot-snackbar-box />
    <network-notification />
  </div>
  <loading-state v-else />
</template>

<script>
import { mapGetters } from 'vuex';
import AddAccountModal from '../dashboard/components/layout/sidebarComponents/AddAccountModal';
import LoadingState from './components/widgets/LoadingState.vue';
import NetworkNotification from './components/NetworkNotification';
import UpdateBanner from './components/app/UpdateBanner.vue';
import vueActionCable from './helper/actionCable';
import WootSnackbarBox from './components/SnackbarContainer';
import rtlMixin from 'shared/mixins/rtlMixin';
import {
  registerSubscription,
  verifyServiceWorkerExistence,
} from './helper/pushHelper';

export default {
  name: 'App',

  components: {
    AddAccountModal,
    LoadingState,
    NetworkNotification,
    UpdateBanner,
    WootSnackbarBox,
  },

  mixins: [rtlMixin],

  data() {
    return {
      showAddAccountModal: false,
      latestChatwootVersion: null,
    };
  },

  computed: {
    ...mapGetters({
      getAccount: 'accounts/getAccount',
      currentUser: 'getCurrentUser',
      globalConfig: 'globalConfig/get',
      authUIFlags: 'getAuthUIFlags',
      currentAccountId: 'getCurrentAccountId',
    }),
    hasAccounts() {
      const { accounts = [] } = this.currentUser || {};
      return accounts.length > 0;
    },
  },

  watch: {
    currentUser() {
      if (!this.hasAccounts) {
        this.showAddAccountModal = true;
      }
    },
    currentAccountId() {
      if (this.currentAccountId) {
        this.initializeAccount();
      }
    },
  },
  mounted() {
    this.setLocale(window.chatwootConfig.selectedLocale);
  },
  methods: {
    setLocale(locale) {
      this.$root.$i18n.locale = locale;
    },
    async initializeAccount() {
      await this.$store.dispatch('accounts/get');
      this.$store.dispatch('setActiveAccount', {
        accountId: this.currentAccountId,
      });
      const {
        locale,
        latest_chatwoot_version: latestChatwootVersion,
      } = this.getAccount(this.currentAccountId);
      const { pubsub_token: pubsubToken } = this.currentUser || {};
      this.setLocale(locale);
      this.updateRTLDirectionView(locale);
      this.latestChatwootVersion = latestChatwootVersion;
      vueActionCable.init(pubsubToken);

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

<style lang="scss">
@import './assets/scss/app';
.update-banner {
  height: var(--space-larger);
  align-items: center;
  font-size: var(--font-size-small) !important;
}
</style>

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>
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
</style>
