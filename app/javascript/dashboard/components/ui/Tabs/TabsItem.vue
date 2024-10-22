<script setup>
import { computed, inject } from 'vue';

const props = defineProps({
  index: {
    type: Number,
    default: 0,
  },
  name: {
    type: String,
    required: true,
  },
  disabled: {
    type: Boolean,
    default: false,
  },
  count: {
    type: Number,
    default: 0,
  },
  showBadge: {
    type: Boolean,
    default: true,
  },
});

const activeIndex = inject('activeIndex');
const updateActiveIndex = inject('updateActiveIndex');

const active = computed(() => props.index === activeIndex.value);
const getItemCount = computed(() => props.count);

const onTabClick = event => {
  event.preventDefault();
  if (!props.disabled) {
    updateActiveIndex(props.index);
  }
};
</script>

<template>
  <li
    class="tabs-title"
    :class="{
      'is-active': active,
    }"
  >
    <a @click="onTabClick">
      <span v-if="name != 'Unassigned' && name != 'Mine'">{{ name }}</span>
      <span v-if="name == 'Unassigned'">New Booking</span>
      <span v-if="name == 'Mine'">Mine</span>
      <div v-if="showBadge" class="badge min-w-[20px]">
        <span>
          {{ getItemCount }}
        </span>
      </div>
    </a>
  </li>
</template>
