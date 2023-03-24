<template>
  <div class="contact-conversation--panel">
    <div v-if="!uiFlags.isFetching" class="contact-conversation__wrap">
      <div v-if="!privates.length" class="no-label-message">
        <span>
          {{ $t('CONTACT_PANEL.CONVERSATIONS.NO_RECORDS_FOUND') }}
        </span>
      </div>
      <div v-else class="contact-conversation--list">
          <div v-for="message in privates">
              <div class="private-msg" v-if="message.private" >
                  {{message.content}}
                  <div class="time">{{agentName(message.sender_id)}} - {{formatDateTime(message.created_at)}}</div>
              </div>
          </div>
      </div>
    </div>
    <spinner v-else />
  </div>
</template>

<script>
import ConversationCard from 'dashboard/components/widgets/conversation/ConversationCard';
import { mapGetters } from 'vuex';
import Spinner from 'shared/components/Spinner';
import fromUnixTime from "date-fns/fromUnixTime";
import format from "date-fns/format";

export default {
  components: {
    ConversationCard,
    Spinner,
  },
  props: {
    contactId: {
      type: [String, Number],
      required: true,
    },
    conversationId: {
      type: [String, Number],
      required: true,
    },privates: {
      type: [Array],
      default: () => []
    },

  },
    methods:{
        formatDateTime(time) {
            const unixTime = Date.parse(time) / 1000;
            return format(fromUnixTime(unixTime), 'LLL d, h:mm a');
        },
        agentName(id) {
            for(let i=0; i < this.agents.length; i++) {
                if(this.agents[i].id == id)
                  return this.agents[i].available_name;
            }
            return "N/A";
        },
    },
  computed: {
    previousConversations() {
      return this.conversations.filter(
        conversation => conversation.id === Number(this.conversationId)
      );
    },
    ...mapGetters({
      uiFlags: 'privateNotes/getUIFlags',
      agents: 'agents/getAgents',
    }),
  },
  watch: {
    contactId(newContactId, prevContactId) {
      if (newContactId && newContactId !== prevContactId) {
        this.$store.dispatch('privateNotes/get', newContactId);
      }
    },
  },
  mounted() {
    this.$store.dispatch('privateNotes/get', this.contactId);

      this.$store.dispatch('agents/get');

      this.$store.getters['privateNotes/getPrivateNotes'](
          this.conversationId
      ).then(response => this.privates = response.data)


  },
};
</script>

<style lang="scss" scoped>
.no-label-message {
  margin-bottom: var(--space-normal);
  color: var(--b-500);
}
.private-msg {
  background: #fff3d5;
  border: 1px solid #ffdb7f;
  margin: 5px;
  padding: 10px;
  border-radius: 5px;
}
.private-msg .time {
  color:#99b3c9;
  font-size: 1rem;
}
</style>
