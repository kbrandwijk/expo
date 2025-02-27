import ViewPager from '@react-native-community/viewpager';
import React from 'react';
import { Platform, StyleSheet, Text, View } from 'react-native';

export default function ViewPagerScreen() {
  return (
    <ViewPager
      style={styles.container}
      initialPage={0}
      transitionStyle={Platform.OS === 'ios' ? 'curl' : 'scroll'}
      onPageSelected={(_) => {
        console.log('New page!');
      }}>
      <View key="1" style={styles.page}>
        <Text style={styles.text}>First page</Text>
        <Text style={styles.description}>Swipe this to scroll to the next page</Text>
      </View>
      <View key="2" style={styles.page}>
        <Text style={styles.text}>Second page</Text>
        <Text style={styles.description}>Swipe this to scroll back</Text>
      </View>
    </ViewPager>
  );
}

ViewPagerScreen.navigationOptions = {
  title: 'ViewPager Example',
  gesturesEnabled: false,
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  page: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
  text: {
    fontSize: 20,
    fontWeight: 'bold',
  },
  description: {
    fontSize: 16,
    color: '#888',
  },
});
