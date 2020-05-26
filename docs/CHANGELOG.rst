
Changelog
=========

`1.1.0 <https://github.com/saltstack-formulas/eclipse-formula/compare/v1.0.0...v1.1.0>`_ (2020-05-26)
---------------------------------------------------------------------------------------------------------

Continuous Integration
^^^^^^^^^^^^^^^^^^^^^^


* **kitchen+travis:** adjust matrix to add ``3000.3`` [skip ci] (\ `54c7cb3 <https://github.com/saltstack-formulas/eclipse-formula/commit/54c7cb3a25e96f5dad9854d3c447c54e9cbab59d>`_\ )
* **linters:** change none to null (\ `4aa1c70 <https://github.com/saltstack-formulas/eclipse-formula/commit/4aa1c7037c3d9355e8c25cde42d094e0bcd09c62>`_\ )
* **linters:** satisfy yamllint (\ `e604818 <https://github.com/saltstack-formulas/eclipse-formula/commit/e60481803bfea250014b84e03370cde2e81f9229>`_\ )
* **travis:** add notifications => zulip [skip ci] (\ `5941084 <https://github.com/saltstack-formulas/eclipse-formula/commit/5941084e7df76de9100608f165988059841e3b5d>`_\ )

Features
^^^^^^^^


* **semantic-release:** standardise for this formula (\ `968c1c5 <https://github.com/saltstack-formulas/eclipse-formula/commit/968c1c5e17fe30f257038e64159ccb4c05f6c63c>`_\ )

`1.0.0 <https://github.com/saltstack-formulas/eclipse-formula/compare/v0.4.0...v1.0.0>`_ (2020-05-06)
---------------------------------------------------------------------------------------------------------

Bug Fixes
^^^^^^^^^


* **macos:** add user to osfamilymap (\ `a05dbe6 <https://github.com/saltstack-formulas/eclipse-formula/commit/a05dbe659500454e19741f1ee71cdd29c0a2099f>`_\ )
* **yamllint:** fix all errors (\ `cc91e18 <https://github.com/saltstack-formulas/eclipse-formula/commit/cc91e1809dd3ba5275f3072043203e4d5f927a17>`_\ )

Features
^^^^^^^^


* **formula:** major rewrite, align to template-formula (\ `bbbecab <https://github.com/saltstack-formulas/eclipse-formula/commit/bbbecab0dcfb70a789cc1f3d4dde34d8b8cfecf4>`_\ )
* **semantic-release:** standardise for this formula (\ `8922bde <https://github.com/saltstack-formulas/eclipse-formula/commit/8922bde5288317559ec6845b4296cf7585b01f4a>`_\ )

BREAKING CHANGES
^^^^^^^^^^^^^^^^


* **formula:** Major refactor of formula to bring it in alignment with the
  .  As with all substantial changes, please ensure your
  existing configurations work in the ways you expect from this formula.
