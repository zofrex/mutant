Known Problems
==============

Mutations with Infinite Runtimes
---------------------------------

Occasionally mutant will produce a mutation with an infinite runtime. When this happens
mutant will look like it is running indefinitely without killing a remaining mutation. To
avoid mutations like this, consider adding a timeout around your tests. For example, in
RSpec you can add the following to your `spec_helper`:
```ruby
config.around(:each) do |example|
  Timeout.timeout(5, &example)
end
```
which will fail specs which run for longer than 5 seconds.

The Crash / Stuck Problem (MRI)
-------------------------------

Mutations generated by mutant can cause MRI to enter VM states its not prepared for.
All MRI versions > 1.9 and < 2.2.1 are affected by this depending on your compiler flags,
compiler version, and OS scheduling behavior.

This can have the following unintended effects:

* MRI crashes with a segfault. Mutant kills each mutation in a dedicated fork to isolate
  the mutations side effects when this fork terminates abnormally (segfault) mutant
  counts the mutation as killed.

* MRI crashes with a segfault and gets stuck when handling the segfault.
  Depending on the number of active kill jobs mutant might appear to continue normally until
  all workers are stuck into this state when it begins to hang.
  Currently mutant must assume that your test suite simply not terminated yet as from the outside
  (parent process) the difference between a long running test and a stuck MRI is not observable.
  Its planned to implement a timeout enforced from the parent process, but ideally MRI simply gets fixed.

References:

* [MRI fix](https://github.com/ruby/ruby/commit/8fe95fea9d238a6deb70c8953ceb3a28a67f4636)
* [MRI backport to 2.2.1](https://github.com/ruby/ruby/commit/8fe95fea9d238a6deb70c8953ceb3a28a67f4636)
* [Mutant issue](https://github.com/mbj/mutant/issues/265)
* [Upstream bug redmine](https://bugs.ruby-lang.org/issues/10460)
* [Upstream bug github](https://github.com/ruby/ruby/pull/822)