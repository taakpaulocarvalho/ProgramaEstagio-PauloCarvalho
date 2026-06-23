trigger OrderItemTrigger on OrderItem (before insert, before update) {

    new OrderItemHandler().run();
}