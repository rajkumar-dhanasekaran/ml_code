import tensorflow as tf
hello = tf.constant('Hello, TensorFlow!')
sess = tf.Session()
print(sess.run(hello))

a = tf.constant(10)
b = tf.constant(32)
print(sess.run(a + b))

#Another version
# import tensorflow
import tensorflow as tf

# build computational graph
a = tf.placeholder(tf.int16)
b = tf.placeholder(tf.int16)

addition = tf.add(a, b)

# initialize variables
init = tf.initialize_all_variables()

# create session and run the graph
with tf.Session() as sess:
    sess.run(init)
    print "Addition: %i" % sess.run(addition, feed_dict={a: 2, b: 3})

# close session
sess.close()