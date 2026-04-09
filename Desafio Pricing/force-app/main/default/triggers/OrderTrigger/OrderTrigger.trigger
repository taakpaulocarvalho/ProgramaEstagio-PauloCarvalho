trigger OrderTrigger on Order (after update, before update) {

    new OrderHandler().run();
}